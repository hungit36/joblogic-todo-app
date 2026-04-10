//
//  RetryPolicy.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

struct RetryPolicy {
    let maxRetries: Int
    let baseDelay: TimeInterval

    func execute<T>(
        _ block: @escaping () async throws -> T
    ) async throws -> T {

        var attempt = 0

        while true {
            do {
                return try await block()
            } catch {
                attempt += 1

                if !shouldRetry(error) || attempt >= maxRetries {
                    throw error
                }

                // ⛔️ Check cancel
                try Task.checkCancellation()

                // 📈 Exponential backoff
                let delay = baseDelay * pow(2, Double(attempt - 1))

                try await Task.sleep(
                    nanoseconds: UInt64(delay * 1_000_000_000)
                )
            }
        }
    }

    private func shouldRetry(_ error: Error) -> Bool {
        if let appError = error as? AppError {
            switch appError {
            case .serverError(let code):
                return (500...599).contains(code)
            case .invalidResponse:
                return true
            case .decoding,  .network,  .database,  .unknown(_):
                return false
            }
        }

        return true
    }
}

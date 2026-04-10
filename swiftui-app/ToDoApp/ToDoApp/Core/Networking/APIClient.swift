//
//  APIClient.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class APIClient {

    private let retry: RetryPolicy
    private let session: URLSession
    
    init(
        retry: RetryPolicy = RetryPolicy(maxRetries: 3, baseDelay: 1),
        session: URLSession = .shared
    ) {
        self.retry = retry
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        do {
            return try await retry.execute {
                try await self.performRequest(endpoint)
            }
        } catch {
            if shouldFallback(error) {
                return try await mockRequest(endpoint)
            } else {
                throw error
            }
        }
    }

    // MARK: - REAL API
    private func performRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.serverError(statusCode: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - MOCK
    private func mockRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await Task.sleep(nanoseconds: 300_000_000)

        let data = MockData.getData(for: endpoint)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw AppError.decoding
        }
    }

    // MARK: - Fallback Rule
    private func shouldFallback(_ error: Error) -> Bool {

        // URLSession error
        if error is URLError {
            return true
        }

        if let appError = error as? AppError {
            switch appError {

            case .serverError(let code):
                return (500...599).contains(code)

            case .invalidResponse:
                return true

            case .decoding, .database, .unknown(_), .network:
                return false

            }
        }

        return false
    }
}


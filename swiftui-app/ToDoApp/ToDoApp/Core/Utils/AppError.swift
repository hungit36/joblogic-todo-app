//
//  AppError.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

enum AppError: Error, LocalizedError {
    case network
    case decoding
    case database
    case invalidResponse
    case serverError(statusCode: Int)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .network: return "Network error"
        case .decoding: return "Decoding error"
        case .database: return "Database error"
        case .unknown(let msg): return msg
        case .invalidResponse: return "Invalid response"
        case .serverError(statusCode: let statusCode): return "Server error with status code: \(statusCode)"
        }
    }
}

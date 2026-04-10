//
//  APIClientTests.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import XCTest

@testable import ToDoApp

final class APIClientTests: XCTestCase {

    func test_request_success() async throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]

        let session = URLSession(configuration: config)

        // Mock response
        MockURLProtocol.requestHandler = { request in
            let json = """
            { "name": "John" }
            """.data(using: .utf8)!

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, json)
        }

        let api = APIClient(session: session)

        struct User: Decodable {
            let name: String
        }

        let result: User = try await api.request(.buyItems)

        XCTAssertEqual(result.name, "John")
    }
    
    func test_request_retry_then_success() async throws {

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]

        let session = URLSession(configuration: config)

        var callCount = 0

        MockURLProtocol.requestHandler = { request in
            callCount += 1

            if callCount == 1 {
                throw URLError(.timedOut)
            }

            let json = """
            { "id": 99 }
            """.data(using: .utf8)!

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, json)
        }

        let api = APIClient(session: session)

        struct Model: Decodable {
            let id: Int
        }

        let result: Model = try await api.request(.buyItems)

        XCTAssertEqual(result.id, 99)
        XCTAssertEqual(callCount, 2) 
    }
}

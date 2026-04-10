//
//  Endpoint.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

private let baseURL: URL = URL(string: "https://mock.api")!

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum Endpoint {
    case persons(page: Int, query: String?)
    case buyItems
    case syncSell

    var url: URL {
        switch self {
        case let .persons(page, query):
            var components = URLComponents(url: baseURL.appendingPathComponent("persons"), resolvingAgainstBaseURL: false)!
            components.queryItems = [
                URLQueryItem(name: "page", value: "\(page)")
            ]

            if let query = query {
                components.queryItems?.append(URLQueryItem(name: "query", value: query))
            }

            return components.url!

        case .buyItems:
            return baseURL.appendingPathComponent("buy")

        case .syncSell:
            return baseURL.appendingPathComponent("sell")
        }
    }

    var method: String {
        switch self {
        case .persons:
            return HTTPMethod.GET.rawValue
        case .buyItems:
            return HTTPMethod.GET.rawValue
        case .syncSell:
            return HTTPMethod.POST.rawValue
        }
    }

    var body: [String: Any]? {
        switch self {
        case .syncSell:
            return [
                "items": [1, 2, 3]
            ]
        default:
            return nil
        }
    }
}

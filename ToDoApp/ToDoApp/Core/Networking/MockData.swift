//
//  MockData.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class MockData {

    static func getData(for endpoint: Endpoint) -> Data {
        switch endpoint {
        case .persons:
            return personsJSON.data(using: .utf8)!
        case .buyItems:
            return buyJSON.data(using: .utf8)!
        case .syncSell:
            return "{}".data(using: .utf8)!
        }
    }

    static let personsJSON = """
    [
        { "id": 1, "name": "Hưng Nguyễn", "phone": "+84963907817"},
        { "id": 2, "name": "Hung Nguyen", "phone": "+84913303091"}
    ]
    """

    static let buyJSON = """
    [
        { "id": 1, "name": "Laptop", "price": 1200, "description": "Macbook" },
        { "id": 2, "name": "Phone", "price": 800, "description": "iPhone" }
    ]
    """
}

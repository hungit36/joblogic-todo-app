//
//  PersonRepositoryImpl.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class PersonRepositoryImpl: PersonRepository {

    private let api: APIClient

    init(api: APIClient) {
        self.api = api
    }

    func fetchPersons(page: Int, query: String?) async throws -> [Person] {

        let dtos: [PersonDTO] = try await api.request(.persons(page: page, query: query))

        var items = dtos.map { $0.toDomain() }

        // Server usually handles, but fallback client filter
        if let query = query, !query.isEmpty {
            items = items.filter {
                $0.name.localizedStandardContains(query.lowercased()) || $0.phone.localizedStandardContains(query.lowercased())
            }
        }

        return items
    }
}

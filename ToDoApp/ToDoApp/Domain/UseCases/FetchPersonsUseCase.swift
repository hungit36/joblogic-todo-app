//
//  FetchPersonsUseCase.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class FetchPersonsUseCase {

    private let repo: PersonRepository

    init(repo: PersonRepository) {
        self.repo = repo
    }

    func execute(page: Int, query: String?) async throws -> [Person] {
        let data = try await repo.fetchPersons(page: page, query: query)

        // Filter client-side (extra safety)
        if let query = query, !query.isEmpty {
            return data.filter {
                $0.name.localizedStandardContains(query.lowercased()) || $0.phone.localizedStandardContains(query.lowercased())
            }
        }

        return data
    }
}

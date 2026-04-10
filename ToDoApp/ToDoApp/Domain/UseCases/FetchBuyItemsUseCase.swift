//
//  FetchBuyItemsUseCase.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class FetchBuyItemsUseCase {

    private let repo: BuyRepository

    init(repo: BuyRepository) {
        self.repo = repo
    }

    func execute(
        query: String?,
        sort: BuySortType?
    ) async throws -> [BuyItem] {

        var items = try await repo.fetchItems()

        // Filter
        if let query = query, !query.isEmpty {
            items = items.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }

        // Sort
        if let sort = sort {
            switch sort {
            case .priceAsc, .none:
                items.sort { $0.price < $1.price }
            case .priceDesc:
                items.sort { $0.price > $1.price }
            }
        }

        return items
    }
}

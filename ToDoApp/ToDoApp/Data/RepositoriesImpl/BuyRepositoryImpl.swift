//
//  BuyRepositoryImpl.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class BuyRepositoryImpl: BuyRepository {

    private let api: APIClient
    private let wishlistKey = "wishlist_ids"

    init(api: APIClient) {
        self.api = api
    }

    func fetchItems() async throws -> [BuyItem] {
        let dtos: [BuyItemDTO] = try await api.request(.buyItems)
        return dtos.map { $0.toDomain() }
    }

    // MARK: - Wishlist
    func getWishlist() -> Set<Int> {
        let ids = UserDefaults.standard.array(forKey: wishlistKey) as? [Int] ?? []
        return Set(ids)
    }

    func toggleWishlist(id: Int) {
        var set = getWishlist()

        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }

        UserDefaults.standard.set(Array(set), forKey: wishlistKey)
    }
}

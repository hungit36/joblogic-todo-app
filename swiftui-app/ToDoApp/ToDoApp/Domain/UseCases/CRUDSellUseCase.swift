//
//  CRUDSellUseCase.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class CRUDSellUseCase {

    private let repo: SellRepository

    init(repo: SellRepository) {
        self.repo = repo
    }

    func fetch() -> [SellItem] {
        repo.fetchLocal()
    }

    func add(item: SellItem) throws {
        guard !item.name.isEmpty else {
            throw AppError.unknown("Name is empty")
        }

        let item = SellItem(
            id: Int.random(in: 1...99999),
            name: item.name,
            price: item.price,
            isSold: false,
            updatedAt: Date(),
            isSynced: false
        )

        repo.add(item)
    }
    
    func markSold(_ id: Int) {
        repo.markSold(id)
    }

    func update(_ item: SellItem) {
        repo.update(item)
    }

    func delete(ids: [Int]) {
        repo.delete(ids: ids)
    }
}

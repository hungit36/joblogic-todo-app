//
//  SellRepository.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

protocol SellRepository {

    // Local CRUD
    func fetchLocal() -> [SellItem]
    func add(_ item: SellItem)
    func update(_ item: SellItem)
    func delete(ids: [Int])
    func markSold(_ id: Int)

    // Sync
    func sync(items: [SellItem]) async throws
}


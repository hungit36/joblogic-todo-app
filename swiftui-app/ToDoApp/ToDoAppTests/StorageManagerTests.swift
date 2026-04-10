//
//  StorageManagerTests.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import XCTest
@testable import ToDoApp

final class StorageManagerTests: XCTestCase {

    func makeTestStorage() -> StorageManager {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".json")

        return StorageManager(fileURL: url)
    }

    func test_insert_item() {
        let storage = makeTestStorage()

        let item = SellItem(
            id: 1,
            name: "Item \(Int.random(in: 1...99999))",
            price: Double.random(in: 1...99999),
            isSold: false,
            updatedAt: Date(),
            isSynced: false
        )

        storage.insert(item)

        let result = storage.fetch()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, 1)
    }
    
    func test_update_item() {
        let storage = makeTestStorage()

        let item = SellItem(
            id: 1,
            name: "Item \(Int.random(in: 1...99999))",
            price: Double.random(in: 1...99999),
            isSold: false,
            updatedAt: Date(),
            isSynced: false
        )
        storage.insert(item)

        var updated = item
        updated.isSold = true

        storage.update(updated)

        let result = storage.fetch()

        XCTAssertEqual(result.first?.isSold, true)
    }
    
    func test_delete_item() {
        let storage = makeTestStorage()

        storage.insert(
            SellItem(
                id: 1,
                name: "Item \(Int.random(in: 1...99999))",
                price: Double.random(in: 1...99999),
                isSold: false,
                updatedAt: Date(),
                isSynced: false
            )
        )
        storage.insert(
            SellItem(
                id: 2,
                name: "Item \(Int.random(in: 1...99999))",
                price: Double.random(in: 1...99999),
                isSold: false,
                updatedAt: Date(),
                isSynced: false
            )
        )

        storage.delete([1])

        let result = storage.fetch()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, 2)
    }
    
    func test_mark_sold() {
        let storage = makeTestStorage()

        storage.insert(
            SellItem(
                id: 1,
                name: "Item \(Int.random(in: 1...99999))",
                price: Double.random(in: 1...99999),
                isSold: false,
                updatedAt: Date(),
                isSynced: false
            )
        )

        storage.markSold(id: 1)

        let item = storage.fetch().first

        XCTAssertEqual(item?.isSold, true)
        XCTAssertEqual(item?.isSynced, false) // 🔥 important
    }
    
    func test_pending_sync_items() {
        let storage = makeTestStorage()

        storage.insert(
            SellItem(
                id: 1,
                name: "Item \(Int.random(in: 1...99999))",
                price: Double.random(in: 1...99999),
                isSold: false,
                updatedAt: Date(),
                isSynced: false
            )
        )
        storage.insert(
            SellItem(
                id: 2,
                name: "Item \(Int.random(in: 1...99999))",
                price: Double.random(in: 1...99999),
                isSold: false,
                updatedAt: Date(),
                isSynced: false
            )
        )

        let pending = storage.getPendingSyncItems()

        XCTAssertEqual(pending.count, 1)
        XCTAssertEqual(pending.first?.id, 1)
    }
}

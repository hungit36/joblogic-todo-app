//
//  SellRepositoryImpl.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class SellRepositoryImpl: SellRepository {

    private let db: StorageManager
    private let api: APIClient

    // Queue for offline sync
    private var pendingSync: [SellItem] = []

    init(db: StorageManager, api: APIClient) {
        self.db = db
        self.api = api
    }

    // MARK: - Local CRUD

    func fetchLocal() -> [SellItem] {
        db.fetch()
    }

    func add(_ item: SellItem) {
        db.insert(item)
    }

    func update(_ item: SellItem) {
        db.update(item)

        // If sold → mark for sync
        if item.isSold {
            pendingSync.append(item)
        }
    }
    
    func markSold(_ id: Int) {
        db.markSold(id: id)
    }

    func delete(ids: [Int]) {
        db.delete(ids)
    }

    // MARK: - Sync

    func sync(items: [SellItem]) async throws {

        guard !items.isEmpty else { return }

        _ = items.map { SellItemDTO.fromDomain($0) }

        do {
            let _: EmptyResponse = try await api.request(.syncSell)

            // Clear pending after success
            pendingSync.removeAll()

        } catch {
            Logger.error("Sync failed, keep in queue")
            pendingSync.append(contentsOf: items)
            throw error
        }
    }
}

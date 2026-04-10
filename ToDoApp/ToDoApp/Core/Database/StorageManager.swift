//
//  SQLiteManager.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class StorageManager {

    static let shared = StorageManager()

    private var storage: [SellItem] = []
    
    private let fileURL: URL
    
    init(fileURL: URL? = nil) {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = fileURL ?? doc.appendingPathComponent("sell_items.json")

        load()
    }

    // MARK: - Read
    func fetch() -> [SellItem] {
        storage
    }

    // MARK: - Insert
    func insert(_ item: SellItem) {
        storage.append(item)
        save()
    }

    // MARK: - Update
    func update(_ item: SellItem) {
        guard let index = storage.firstIndex(where: { $0.id == item.id }) else { return }
        storage[index] = item
        save()
    }

    // MARK: - Delete
    func delete(_ ids: [Int]) {
        storage.removeAll { ids.contains($0.id) }
        save()
    }

    // MARK: - MARK SOLD (Offline-first core)
    func markSold(id: Int) {
        guard let index = storage.firstIndex(where: { $0.id == id }) else { return }

        storage[index].isSold = true
        storage[index].updatedAt = Date()
        storage[index].isSynced = false   // 🔥 important for sync

        save()
    }

    // MARK: - Sync helpers

    /// Items that need sync with server
    func getPendingSyncItems() -> [SellItem] {
        storage.filter { $0.isSold && !$0.isSynced }
    }

    /// Mark item synced after API success
    func markSynced(ids: [Int]) {
        for id in ids {
            if let index = storage.firstIndex(where: { $0.id == id }) {
                storage[index].isSynced = true
            }
        }
        save()
    }

    // MARK: - Persistence

    private func save() {
        do {
            let data = try JSONEncoder().encode(storage)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            Logger.error("Save error: \(error.localizedDescription)")
        }
    }

    private func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            storage = try JSONDecoder().decode([SellItem].self, from: data)
        } catch {
            storage = []
        }
    }
}

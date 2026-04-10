//
//  SyncSellUseCase.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class SyncSellUseCase {

    private let repo: SellRepository

    init(repo: SellRepository) {
        self.repo = repo
    }

    func execute() async throws {

        let localItems = repo.fetchLocal()

        // Only sync sold items
        let toSync = localItems.filter { $0.isSold }

        guard !toSync.isEmpty else { return }

        try await repo.sync(items: toSync)
    }
}

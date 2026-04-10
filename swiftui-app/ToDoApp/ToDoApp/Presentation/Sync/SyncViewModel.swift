//
//  SyncViewModel.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation
import Combine

@MainActor
final class SyncViewModel: ObservableObject {

    @Published var isSyncing = false
    @Published var message: String?

    private let useCase: SyncSellUseCase
    private let syncManager: BackgroundSyncManager

    init(useCase: SyncSellUseCase,
         syncManager: BackgroundSyncManager) {
        self.useCase = useCase
        self.syncManager = syncManager
    }

    func sync() {
        guard !isSyncing else { return }

        isSyncing = true

        syncManager.run {
            do {
                try await self.useCase.execute()
                await MainActor.run {
                    self.message = "Sync success"
                    self.isSyncing = false
                }
            } catch {
                await MainActor.run {
                    self.message = error.localizedDescription
                    self.isSyncing = false
                }
            }
        }
    }
}

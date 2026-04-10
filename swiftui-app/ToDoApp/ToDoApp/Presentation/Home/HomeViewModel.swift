//
//  HomeViewModel.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    private let container: AppDIContainer

    @Published var callCount = 0
    @Published var buyCount = 0
    @Published var sellCount = 0

    init(container: AppDIContainer) {
        self.container = container
    }
    
    // MARK: - Factories (match DI exactly)
    func makeToCallViewModel() -> ToCallViewModel {
        container.makeToCallViewModel()
    }

    func makeToBuyViewModel() -> ToBuyViewModel {
        container.makeToBuyViewModel()
    }

    func makeToSellViewModel() -> ToSellViewModel {
        container.makeToSellViewModel()
    }

    func makeSyncViewModel() -> SyncViewModel {
        container.makeSyncViewModel()
    }

    func loadCounters() {
        Task {
            do {
                let persons = try await container.makeFetchPersonsUseCase().execute(page: 1, query: nil)
                let buys = try await container.makeFetchBuyItemsUseCase().execute(query: nil, sort: nil)
                let sells = container.makeCRUDSellUseCase().fetch()

                callCount = persons.count
                buyCount = buys.count
                sellCount = sells.count
            } catch {
                Logger.error("Failed to load counters")
            }
        }
    }

    func sync() {
        Task {
            try? await container.makeSyncSellUseCase().execute()
        }
    }
}

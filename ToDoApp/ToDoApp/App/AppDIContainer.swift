//
//  AppDIContainer..swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class AppDIContainer {

    // MARK: - Core
    lazy var apiClient: APIClient = {
        APIClient()
    }()

    lazy var database: StorageManager = {
        StorageManager.shared
    }()

    // MARK: - Repositories
    lazy var personRepository: PersonRepository = {
        PersonRepositoryImpl(api: apiClient)
    }()

    lazy var buyRepository: BuyRepository = {
        BuyRepositoryImpl(api: apiClient)
    }()

    lazy var sellRepository: SellRepository = {
        SellRepositoryImpl(db: database, api: apiClient)
    }()

    // MARK: - UseCases
    func makeFetchPersonsUseCase() -> FetchPersonsUseCase {
        FetchPersonsUseCase(repo: personRepository)
    }

    func makeFetchBuyItemsUseCase() -> FetchBuyItemsUseCase {
        FetchBuyItemsUseCase(repo: buyRepository)
    }

    func makeCRUDSellUseCase() -> CRUDSellUseCase {
        CRUDSellUseCase(repo: sellRepository)
    }

    func makeSyncSellUseCase() -> SyncSellUseCase {
        SyncSellUseCase(repo: sellRepository)
    }

    // MARK: - ViewModels
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(container: self)
    }

    func makeToCallViewModel() -> ToCallViewModel {
        ToCallViewModel(useCase: makeFetchPersonsUseCase())
    }

    func makeToBuyViewModel() -> ToBuyViewModel {
        ToBuyViewModel(useCase: makeFetchBuyItemsUseCase())
    }

    func makeToSellViewModel() -> ToSellViewModel {
        ToSellViewModel(useCase: makeCRUDSellUseCase())
    }

    func makeSyncViewModel() -> SyncViewModel {
        SyncViewModel(
            useCase: makeSyncSellUseCase(),
            syncManager: backgroundSyncManager
        )
    }
    
    lazy var backgroundSyncManager: BackgroundSyncManager = {
        BackgroundSyncManager.shared
    }()
}

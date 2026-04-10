//
//  ToBuyViewModel.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation
import Combine

@MainActor
final class ToBuyViewModel: ObservableObject {
    
    @Published var state: ViewState<[BuyItem]> = .idle
    @Published var wishlist: Set<Int> = []

    // ✅ NEW
    @Published var searchText: String = ""
    @Published var sortType: BuySortType = .none

    private let useCase: FetchBuyItemsUseCase
    private var cancellables = Set<AnyCancellable>()

    init(useCase: FetchBuyItemsUseCase) {
        self.useCase = useCase
        loadWishlist()
        bind()
    }

    func load() async {
        
        do {
            
            state = .loading
            let data = try await useCase.execute(
                query: searchText.isEmpty ? nil : searchText,
                sort: sortType
            )

            // ❗ check cancel
            guard !Task.isCancelled else { return }

            if  case .loaded(let old) = state {
                state = .loaded((old + data).unique(by: \.id))
            } else {
                state = data.isEmpty ? .empty : .loaded(data)
            }
            
        } catch {
            state = .error(error)
            Logger.error(error.localizedDescription)
        }
    }

    // MARK: - Binding (debounce search)
    private func bind() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.load() }
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    func changeSort(_ type: BuySortType) {
        sortType = type
        Task { await load() }
    }

    func toggleWishlist(_ item: BuyItem) {
        if wishlist.contains(item.id) {
            wishlist.remove(item.id)
        } else {
            wishlist.insert(item.id)
        }
        saveWishlist()
    }

    func isWishlisted(_ item: BuyItem) -> Bool {
        wishlist.contains(item.id)
    }

    // MARK: - Storage
    private func saveWishlist() {
        UserDefaults.standard.set(Array(wishlist), forKey: "wishlist")
    }

    private func loadWishlist() {
        let data = UserDefaults.standard.array(forKey: "wishlist") as? [Int] ?? []
        wishlist = Set(data)
    }
}

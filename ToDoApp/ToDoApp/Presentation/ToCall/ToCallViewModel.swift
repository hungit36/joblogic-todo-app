//
//  ToCallViewModel.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation
import Combine
import UIKit

@MainActor
final class ToCallViewModel: ObservableObject {

    @Published var state: ViewState<[Person]> = .idle
    @Published var searchText: String = ""
    @Published var canCallNumber: Bool = false

    private let useCase: FetchPersonsUseCase

    private var page = 1
    private var canLoadMore = true
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(useCase: FetchPersonsUseCase) {
        self.useCase = useCase

        debounceSearch()
    }

    func load() async {
        searchTask?.cancel()
        state = .loading
        page = 1
        canLoadMore = true
        canCallNumber = UIApplication.shared.canOpenURL(URL(string: "tel://+84963907817")!)
        await fetch()
    }
    
    func callNumber(phone: String) {
        if let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.open(url)
        }
    }

    func loadMoreIfNeeded(current: Person) async {
        guard case .loaded(let items) = state,
              let last = items.last,
              last.id == current.id,
              canLoadMore else { return }

        page += 1
        await fetch(append: true)
    }

    private func fetch(append: Bool = false) async {
        do {
            let data = try await useCase.execute(page: page, query: searchText)

            // ❗ check cancel
            guard !Task.isCancelled else { return }

            if data.isEmpty {
                canLoadMore = false
            }

            if append, case .loaded(let old) = state {
                state = .loaded((old + data).unique(by: \.id))
            } else {
                state = data.isEmpty ? .empty : .loaded(data)
            }

        } catch {
            guard !Task.isCancelled else { return }
            state = .error(error)
        }
    }

    private func debounceSearch() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] e in
                Logger.error(String(bytes: e.data(using: .utf8)!, encoding: .utf8) ?? "")
                Task { await self?.load() }
            }
            .store(in: &cancellables)
    }
    
    private func startSearch() {
        searchTask?.cancel()

        searchTask = Task {
            await load()
        }
    }
}

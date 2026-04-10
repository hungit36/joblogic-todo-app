//
//  ToSellViewModel.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation
import Combine

@MainActor
final class ToSellViewModel: ObservableObject {

    @Published var items: [SellItem] = []
    @Published var selectedIds: Set<Int> = []
    @Published var showUndo = false
    @Published var errorMessage: String?
    @Published var soldTotal: Int = 0

    @Published var name: String = ""
    @Published var price: Double = 0
    
    @Published var showAddEditSheet = false
    @Published var isEditing = false
    @Published var editingItem: SellItem?

    private let useCase: CRUDSellUseCase

    private struct DeletedItem {
        let item: SellItem
        let index: Int
    }

    private var lastDeleted: [DeletedItem] = []
    private var undoTask: Task<Void, Never>?

    init(useCase: CRUDSellUseCase) {
        self.useCase = useCase
        load()
    }

    // MARK: - Load
    func load() {
        items = useCase.fetch()
        soldTotal = items.isEmpty ? 0 :  items.filter({$0.isSold}).count
    }
    
    func markSold(_ item: SellItem) {
        do {
            try useCase.markSold(item.id)
            load()

        } catch {
            handleError(error)
        }
    }

    // MARK: - Add / Edit flow
    func openAdd() {
        isEditing = false
        editingItem = nil
        name = ""
        price = 0
        showAddEditSheet = true
    }
    
    func openEdit(_ item: SellItem) {
        isEditing = true
        editingItem = item
        name = item.name
        price = item.price
        showAddEditSheet = true
    }

    func save() {
        do {
            if isEditing {
                guard let item = editingItem else { return }

                let updated = SellItem(
                    id: item.id,
                    name: name,
                    price: price,
                    isSold: item.isSold,
                    updatedAt: Date(),
                    isSynced: item.isSynced
                )

                try SellItemValidator.validate(updated)
                try useCase.update(updated)

            } else {
                let newItem = SellItem(
                    id: Int.random(in: 1_000_000...9_999_999),
                    name: name,
                    price: price,
                    isSold: false,
                    updatedAt: Date(),
                    isSynced: false
                )

                try SellItemValidator.validate(newItem)
                try useCase.add(item: newItem)
            }

            showAddEditSheet = false
            load()

        } catch {
            handleError(error)
        }
    }

    // MARK: - Delete
    func delete(_ item: SellItem) {
        performDelete(items: [item])
    }

    func deleteSelected() {
        let deleted = items.filter { selectedIds.contains($0.id) }
        performDelete(items: deleted)
        selectedIds.removeAll()
    }

    private func performDelete(items: [SellItem]) {
        guard !items.isEmpty else { return }

        do {
            lastDeleted = items.compactMap { item in
                guard let index = self.items.firstIndex(where: { $0.id == item.id }) else {
                    return nil
                }
                return DeletedItem(item: item, index: index)
            }

            try useCase.delete(ids: items.map { $0.id })

            load()
            triggerUndo()

        } catch {
            handleError(error)
        }
    }

    func undo() {
        undoTask?.cancel()

        do {
            // 🔥 ONLY restore to DB
            for deleted in lastDeleted {
                try useCase.add(item: deleted.item)
            }

            lastDeleted.removeAll()
            showUndo = false

            // 🔥 reload SINGLE source of truth
            load()

        } catch {
            handleError(error)
        }
    }

    private func triggerUndo() {
        showUndo = true

        undoTask?.cancel()
        undoTask = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            if !Task.isCancelled {
                showUndo = false
                lastDeleted.removeAll()
            }
        }
    }

    // MARK: - Error
    private func handleError(_ error: Error) {
        if let appError = error as? AppError {
            errorMessage = appError.localizedDescription
        } else {
            errorMessage = "Something went wrong"
        }
    }
}

struct SellItemValidator {

    static func validate(_ item: SellItem) throws {
        guard !item.name.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw AppError.unknown("invalid Name")
        }

        guard item.price > 0 else {
            throw AppError.unknown("invalid Price")
        }
    }
}


//
//  SellItemDTO.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

struct SellItemDTO: Codable {
    let id: Int
    let name: String
    let price: Double
    let isSold: Bool
    let updatedAt: String
    let isSynced: Bool

    func toDomain() -> SellItem {
        SellItem(
            id: id,
            name: name,
            price: price,
            isSold: isSold,
            updatedAt: Date(),
            isSynced: isSynced
        )
    }

    static func fromDomain(_ item: SellItem) -> SellItemDTO {
        SellItemDTO(
            id: item.id,
            name: item.name,
            price: item.price,
            isSold: item.isSold,
            updatedAt: item.updatedAt.toString(),
            isSynced: item.isSynced
        )
    }
}

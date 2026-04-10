//
//  BuyItemDTO.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

struct BuyItemDTO: Codable {
    let id: Int
    let name: String
    let price: Double
    let description: String

    func toDomain() -> BuyItem {
        BuyItem(
            id: id,
            name: name,
            price: price,
            description: description
        )
    }
}

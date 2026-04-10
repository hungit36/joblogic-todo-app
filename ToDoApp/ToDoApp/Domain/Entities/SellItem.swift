//
//  SellItem.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

struct SellItem: Identifiable, Codable, Equatable {
    let id: Int
    var name: String
    var price: Double
    var isSold: Bool
    var updatedAt: Date
    var isSynced: Bool
}


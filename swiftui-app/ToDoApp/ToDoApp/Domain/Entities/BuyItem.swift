//
//  BuyItem.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

struct BuyItem: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let price: Double
    let description: String
}

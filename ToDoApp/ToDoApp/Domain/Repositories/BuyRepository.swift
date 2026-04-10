//
//  BuyRepository.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

protocol BuyRepository {
    func fetchItems() async throws -> [BuyItem]
}

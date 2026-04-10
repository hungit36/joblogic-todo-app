//
//  Person.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

struct Person: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let phone: String
    var updatedAt: Date
}

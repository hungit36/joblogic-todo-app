//
//  PersonDTO.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

struct PersonDTO: Codable {
    let id: Int
    let name: String
    let phone: String

    func toDomain() -> Person {
        Person(id: id, name: name, phone: phone, updatedAt: Date())
    }

}

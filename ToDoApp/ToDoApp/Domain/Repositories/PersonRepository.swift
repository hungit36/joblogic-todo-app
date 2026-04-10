//
//  PersonRepository.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

protocol PersonRepository {
    func fetchPersons(page: Int, query: String?) async throws -> [Person]
}

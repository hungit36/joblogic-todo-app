//
//  ViewState.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case empty
    case error(Error)
}

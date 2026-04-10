//
//  Date+Ext.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

extension Date {
    func toString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm a"
        return f.string(from: self)
    }
}

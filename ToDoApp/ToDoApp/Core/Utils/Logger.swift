//
//  Logger.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation

final class Logger {
    static func log(_ message: String) {
        print("[LOG]: \(message)")
    }

    static func error(_ message: String) {
        print("[ERROR]: \(message)")
    }
}

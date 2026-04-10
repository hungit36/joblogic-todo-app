//
//  BackgroundSyncManager.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation
import UIKit

final class BackgroundSyncManager {

    static let shared = BackgroundSyncManager()

    private var task: UIBackgroundTaskIdentifier = .invalid

    private init() {}

    func begin() {
        task = UIApplication.shared.beginBackgroundTask(withName: "SyncTask") {
            self.end()
        }
    }

    func end() {
        if task != .invalid {
            UIApplication.shared.endBackgroundTask(task)
            task = .invalid
        }
    }

    func run(_ block: @escaping () async -> Void) {
        begin()

        Task {
            await block()
            end()
        }
    }
}

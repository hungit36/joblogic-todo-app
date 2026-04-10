//
//  ToDoApp.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import SwiftUI

@main
struct ToDoApp: App {

    let container = AppDIContainer()

    init() {
        setupNetworkMonitoring()
    }

    var body: some Scene {
        WindowGroup {
            HomeView(vm: container.makeHomeViewModel())
        }
    }
    
    private func setupNetworkMonitoring() {
        let monitor = NetworkMonitor.shared

        monitor.start()

        monitor.onStatusChange = { [weak container] isConnected, isWifi in
            guard isConnected, isWifi else { return }

            Task {
                 container?.makeSyncViewModel().sync()
            }
        }
    }
}

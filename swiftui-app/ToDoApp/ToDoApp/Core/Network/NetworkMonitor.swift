//
//  NetworkMonitor.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import Foundation
import Network

final class NetworkMonitor {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = false
    private(set) var isWifi: Bool = false
    private(set) var isCellular: Bool = false

    var onStatusChange: ((_ isConnected: Bool,_ isWifi: Bool) -> Void)?
    

    private init() {}

    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            let wifi = path.usesInterfaceType(.wifi)
            let cellular = path.usesInterfaceType(.cellular)

            let connected = path.status == .satisfied

            if self.isConnected != connected {
                self.isConnected = connected
                self.isCellular = cellular
                self.isWifi = wifi

                DispatchQueue.main.async {
                    self.onStatusChange?(connected, wifi)
                }
            }
        }

        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
    }
}

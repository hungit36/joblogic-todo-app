//
//  SyncView.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import SwiftUI

struct SyncView: View {

    @StateObject var vm: SyncViewModel

    var body: some View {
        VStack(spacing: 16) {

            Button("Sync Now") {
                vm.sync()
            }
            .disabled(vm.isSyncing)

            if vm.isSyncing {
                ProgressView()
            }

            if let msg = vm.message {
                Text(msg)
            }
        }
        .padding()
    }
}

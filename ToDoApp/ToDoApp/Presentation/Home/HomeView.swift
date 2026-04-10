//
//  HomeView.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var vm: HomeViewModel

    @StateObject private var toCallVM: ToCallViewModel
    @StateObject private var toBuyVM: ToBuyViewModel
    @StateObject private var toSellVM: ToSellViewModel
    @StateObject private var syncVM: SyncViewModel

    init(vm: HomeViewModel) {
        NetworkMonitor.shared.start()
        
        _vm = StateObject(wrappedValue: vm)

        _toCallVM = StateObject(wrappedValue: vm.makeToCallViewModel())
        _toBuyVM = StateObject(wrappedValue: vm.makeToBuyViewModel())
        _toSellVM = StateObject(wrappedValue: vm.makeToSellViewModel())
        _syncVM = StateObject(wrappedValue: vm.makeSyncViewModel())
    }

    var body: some View {
        TabView {

            NavigationView {
                ToCallView(vm: toCallVM)
            }
            .tabItem { Label("To Call", systemImage: "phone") }

            NavigationView {
                ToBuyView(vm: toBuyVM)
            }
            .tabItem { Label("To Buy", systemImage: "cart") }

            NavigationView {
                ToSellView(vm: toSellVM)
            }
            .tabItem { Label("To Sell", systemImage: "dollarsign") }

            NavigationView {
                SyncView(vm: syncVM)
            }
            .tabItem { Label("Sync", systemImage: "arrow.triangle.2.circlepath") }
        }
    }
}

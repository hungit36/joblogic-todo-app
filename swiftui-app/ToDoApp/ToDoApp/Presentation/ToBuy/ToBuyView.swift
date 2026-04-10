//
//  ToBuyView.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import SwiftUI

struct ToBuyView: View {

    @ObservedObject var vm: ToBuyViewModel

    var body: some View {
        List {
            switch vm.state {
            case .loading:
                ProgressView()

            case .empty:
                Text("No data")

            case .error(let err):
                Text(err.localizedDescription)

            case .loaded(let items):
                ForEach(items) { item in
                    NavigationLink {
                        ToBuyDetailView(item: item, vm: vm)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text("\(item.price)")
                            }

                            Spacer()

                            Button {
                                vm.toggleWishlist(item)
                            } label: {
                                Image(systemName: vm.isWishlisted(item) ? "heart.fill" : "heart")
                            }.buttonStyle(.plain)
                        }
                    }
                    
                }

            default:
                EmptyView()
            }
        }.searchable(text: $vm.searchText) // ✅ SEARCH
            .toolbar {
                Menu {
                    Button("Price ↑") {
                        vm.changeSort(.priceAsc)
                    }
                    Button("Price ↓") {
                        vm.changeSort(.priceDesc)
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }.onAppear {
            Task { await vm.load() }
        }
        
    }
}

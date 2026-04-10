//
//  ToCallView.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import SwiftUI

struct ToCallView: View {

    @ObservedObject var vm: ToCallViewModel

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
                ForEach(items) { person in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(person.name)
                            Text(person.phone)
                            Text(person.updatedAt.toString())
                        }
                        .onAppear {
                            Task { await vm.loadMoreIfNeeded(current: person) }
                        }
                        Spacer()
                        if(vm.canCallNumber) {
                            Button {
                                vm.callNumber(phone: person.phone)
                            } label: {
                                Image(systemName: "phone")
                                    .foregroundColor(.blue)
                                    .padding(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

            default:
                EmptyView()
            }
        }
        .searchable(text: $vm.searchText)
        .onAppear {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).clearButtonMode = .never
            Task { await vm.load() }
        }
    }
}

//
//  ToSellView.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import SwiftUI

struct ToSellView: View {

    @ObservedObject var vm: ToSellViewModel

    var body: some View {
        NavigationStack {
            List(selection: $vm.selectedIds) {
                ForEach(vm.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)

                            Text("$\(item.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            if (item.isSold) {
                                Text("Sold")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                            
                        }

                        Spacer()
                        if(!item.isSold) {
                            Button {
                                vm.markSold(item)
                            } label: {
                                Image(systemName: "dollarsign")
                                    .foregroundColor(.blue)
                                    .padding(8)
                            }
                            .buttonStyle(.plain)
                            
                            Button {
                                vm.openEdit(item)
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                                    .padding(8)
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            vm.delete(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(.active))

            // MARK: Toolbar
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        vm.openAdd()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .title) {
                    Button {
                        
                    } label: {
                        Text("Sold: \(vm.soldTotal)")
                            .font(.headline)
                    }
                }
                
                

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete Selected") {
                        vm.deleteSelected()
                    }
                    .disabled(vm.selectedIds.isEmpty)
                }
            }

            // MARK: Undo
            .alert("Items Deleted", isPresented: $vm.showUndo) {
                Button("Undo") {
                    vm.undo()
                }
                Button("Dismiss", role: .cancel) { }
            }

            // MARK: Add Sheet
            .sheet(isPresented: $vm.showAddEditSheet) {
                VStack(spacing: 16) {

                    Text(vm.isEditing ? "Edit Item" : "Add Item To Sell")
                        .font(.title2)
                        .bold()

                    TextField("Name", text: $vm.name)
                        .textFieldStyle(.roundedBorder)

                    TextField("Price", value: $vm.price, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)

                    HStack {
                        Button("Cancel") {
                            vm.showAddEditSheet = false
                        }

                        Spacer()

                        Button(vm.isEditing ? "Save" : "Add") {
                            vm.save()
                        }
                        .disabled(vm.name.isEmpty || vm.price <= 0)
                    }
                }
                .padding()
                .presentationDetents([.height(250)])
            }
        }
    }
}

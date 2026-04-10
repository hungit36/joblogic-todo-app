//
//  ToBuyDetailView.swift
//  ToDoApp
//
//  Created by hungnguyen.it36@gmail.com on 10/4/26.
//

import SwiftUI

struct ToBuyDetailView: View {

    let item: BuyItem
    @ObservedObject var vm: ToBuyViewModel

    var body: some View {
        VStack {
            Text(item.name)
            Text("\(item.price)")

            Button("Wishlist") {
                vm.toggleWishlist(item)
            }
        }
    }
}

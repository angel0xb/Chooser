//
//  ListView.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 1/2/20.
//  Copyright © 2020 AngelRodriguez. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @State var list: AList
    @State var showRandomItem: Bool = false
    @State var item: ListItem = ListItem()
    @Binding var isActive: Bool
    var body: some View {

        VStack {
            NavigationLink(destination: NewListView(viewModel: NewListViewModel(list: list, isEditing: true), listTitle: list.title, shouldPopToRootView: $isActive)) {
                Text("Edit")
            }.isDetailLink(false)
            List {
                ForEach(Array(list.items), id: \.title) { item in
                ExistingItemView(item: item)
                }
            }
            
            
            Button(action: {
                self.item = self.list.items.randomElement() ?? ListItem()
                self.showRandomItem.toggle()
            }){
                Image(systemName: "questionmark.diamond.fill")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color.yellow)

            }.sheet(isPresented: $showRandomItem) {
                Text(self.item.title)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding()
                Text(self.item.info)
            }
        }
        .navigationBarTitle(list.title)
    }
    
}


struct ExistingItemView: View {
    @State var item: ListItem
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .fontWeight(.bold)
            Text(item.info)
                .font(.caption)
        }
    }
}


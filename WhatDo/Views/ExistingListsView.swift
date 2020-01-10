//
//  ExistingListView.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/31/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//

import SwiftUI

struct ExistingListsView: View {
    @ObservedObject var viewModel: ExistingListsViewModel = ExistingListsViewModel()
    @Binding var isActive: Bool
    var body: some View {
        
        List {
            
            ForEach(viewModel.lists, id: \.self) { list in
                NavigationLink(destination: ListView(list: list, isActive: self.$isActive)) {
                    ListTitleView(list: list)
                }.isDetailLink(false)
            }.onDelete(perform: delete)

        }
//        .onAppear {
//            self.viewModel.retrieveLists()
//        }
        .navigationBarTitle(Text("My Lists"))
    }
    
    
    func delete(at offsets: IndexSet) {
        var array = Array(viewModel.lists)
        array.remove(atOffsets: offsets)
        print(viewModel.lists)
    }
}

struct ListTitleView: View {
    @State var list: AList
    var body: some View {
        VStack {
            Text(list.title)
                .font(.title)
        }
    }
}
//struct ExistingListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExistingListView()
//    }
//}

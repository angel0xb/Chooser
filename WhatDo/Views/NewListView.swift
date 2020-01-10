//
//  NewListView.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/20/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//

import SwiftUI

struct NewListView: View {
    @ObservedObject var viewModel: NewListViewModel = NewListViewModel()
    @State var listTitle: String = ""
    @State var showAddNewItemView: Bool = false
    @State var showTitleAlert: Bool = false
    @Binding var shouldPopToRootView: Bool 
    
    var body: some View {
        
        return VStack {
            if !showAddNewItemView {
                TextField("Enter List Title", text: $listTitle)
                    .font(.title)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                self.showAddNewItemView.toggle()
            }) {
                
                if showAddNewItemView {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .padding(.top)
                            .padding(.trailing)
                    }
                    
                } else {
                    HStack {
                        Spacer()
                        Text("New Item")
                            .fontWeight(.bold)
                            .padding(.top)
                        Image(systemName: "plus.square.fill.on.square.fill")
                            .padding(.top)
                            .padding(.trailing)
                    }.foregroundColor(.green)
                }
            }
            
            if showAddNewItemView {
                NewItemView(viewModel: viewModel)
                    .background(Color.pink)
                //                        .frame(minWidth: 0, maxWidth: 300, minHeight: 0, maxHeight: 150)
                //                        .padding([.horizontal])
                //                        .cornerRadius(40)
            }
            
            Text("Current List Items")
                .font(.title)
                .fontWeight(.bold)
            
            List {
                ForEach(Array(self.viewModel.items), id: \.title) { item in
                    ExistingItemView(item: item)
                }.onDelete(perform: viewModel.deleteItem)
            }
            
            Button(action: {
                self.showAddNewItemView = false
                if !self.listTitle.isEmpty {
                    self.viewModel.listTitle = self.listTitle
                    self.viewModel.saveList()
                    self.shouldPopToRootView = false
                } else {
                    self.showTitleAlert = true
                }
                
            }){
                Text("Save")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
            }
        }
        .alert(isPresented: $showTitleAlert) {
            return Alert(title: Text("List title cannot be empty."), message: Text("Please add title."), dismissButton: .default(Text("Ok")))
        }
        .navigationBarTitle(Text(!viewModel.isEditing ? "New List: \(listTitle)" : "Editing List: \(listTitle)"), displayMode: .inline)
    }
}

struct NewItemView: View {
    @ObservedObject var viewModel: NewListViewModel
    @State var title: String = ""
    @State var info: String = ""
    @State var showAlert: Bool = false
    
    var body: some View {
        let titleBinding = Binding<String>(get: {
            self.title
        }, set: {
            self.title = $0
        })
        
        let infoBinding = Binding<String>(get: {
            self.info
        }, set: {
            self.info = $0
        })
        
        return VStack {
            Text("New Item")
                .font(.title)
                .fontWeight(.bold)
            HStack {
                Text("Title")
                    .font(.subheadline)
                Spacer() 
            }
            
            TextField("Title", text: titleBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Item title cannot be empty."), message: Text("Please add title."), dismissButton: .default(Text("Ok")))
            }
            //            Image(uiImage: UIImage(data: item.imgData) ?? UIImage())
            
            HStack {
                Text("Description")
                    .font(.subheadline)
                Spacer()
            }
            
            TextField("Description", text: infoBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                if self.title.isEmpty {
                    self.showAlert = true
                } else {
                    self.viewModel.addItem(title: self.title, info: self.info)
                    self.title = ""
                    self.info = ""
                }
            }){
                Text("Add Item")
            }
            .padding()
        }
    }
}

//struct NewListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewListView(viewModel: NewListViewModel(), listTitle: "")
//        .environment(\.colorScheme, .dark)
//    }
//}

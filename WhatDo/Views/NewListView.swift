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
    
    var animation: Animation {
          Animation.spring(dampingFraction: 0.5)
              .speed(2)
      }
    
    var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    var body: some View {
        
        return VStack {
            if !showAddNewItemView {
                TextField("Enter List Title", text: $listTitle)
                    .font(.title)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .transition(self.moveAndFade)
            }
            
            Button(action: {
                withAnimation {
                    self.showAddNewItemView.toggle()
                }
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
                NewItemView(viewModel: viewModel, isShown: $showAddNewItemView)
                    .transition(.slide)
                    .background(Color.pink)
                Text("Current List Items")
                    .font(.title)
                    .fontWeight(.bold)
                    .transition(.opacity)
            }
            
            List {
                ForEach(Array(self.viewModel.items), id: \.title) { item in
                    ExistingItemView(item: item)
                }.onDelete(perform: viewModel.deleteItem)
            }
            
            Button(action: {
                self.showAddNewItemView = false
                if !self.listTitle.isEmpty && !self.$viewModel.items.wrappedValue.isEmpty {
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
            return listTitle.isEmpty ? Alert(title: Text("List title cannot be empty."), message: Text("Please add title."), dismissButton: .default(Text("Ok"))) : Alert(title: Text("List must contain an item."), message: Text("Please add item(s)."), dismissButton: .default(Text("Ok")))
        }
        .navigationBarTitle(Text("\(viewModel.getNavBarTitle()) \(listTitle)"), displayMode: .inline)
    }
}

struct NewItemView: View {
    @ObservedObject var viewModel: NewListViewModel
    @State var title: String = ""
    @State var info: String = ""
    @State var showAlert: Bool = false
    @Binding var isShown: Bool
    
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
                withAnimation(Animation.easeInOut) {
                    if self.title.isEmpty {
                          self.showAlert = true
                      } else {
                          self.viewModel.addItem(title: self.title, info: self.info)
                          self.title = ""
                          self.info = ""
                          self.isShown.toggle()
                      }
                }
            }){
                Text("Add Item")
            }
            .padding()
        }.transition(.slide)
    }
}

//struct NewListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewListView(viewModel: NewListViewModel(), listTitle: "")
//        .environment(\.colorScheme, .dark)
//    }
//}

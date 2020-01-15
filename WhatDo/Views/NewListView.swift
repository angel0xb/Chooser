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
                    .animation(animation)
            }
            
            Button(action: {
                withAnimation {
                    self.showAddNewItemView.toggle()
                }
            }) {
                
                if showAddNewItemView {
                    HStack {
                        Spacer()
                        Image(systemName: "xmark.circle")
                            .padding(7)
                            .foregroundColor(Color.gray)
                    }
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
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
                    .background(Color.gray.cornerRadius(10))
                    .padding(.horizontal, 30)
                    .padding(.top, -10)
                
                Text("Current List Items")
                    .font(.title)
                    .fontWeight(.bold)
                    .transition(.opacity)
                    .padding(.top)
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
    @State var image: Image? = nil
    @State var showImageCaptureView: Bool = false
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
            //                .padding(.top)
            HStack {
                Text("Title")
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .padding(.leading)
                Spacer() 
            }
            
            TextField("Title", text: titleBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 30)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Item title cannot be empty."), message: Text("Please add title."), dismissButton: .default(Text("Ok")))
            }
            
            HStack {
                Text("Description")
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .padding(.leading)
                Spacer()
            }
            
            TextField("Description", text: infoBinding)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 30)
            
            Button(action: {
                print("add image")
                self.showImageCaptureView.toggle()
            }){
                
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                
            }.sheet(isPresented: self.$showImageCaptureView) {
                CaptureImageView(isShown: self.$showImageCaptureView, image: self.$image)
            }
            
            
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
                    .fontWeight(.bold)
            }
            .padding(.bottom)
            //            func getImage() -> Image {
            //                var img: Image
            //                if image != nil  {
            //                    img = image!
            //                } else {
            //                    img = Image(systemName: "photo")
            //
            //                }
            //                return img
            //                    .resizable()
            //                    .frame(width: 150, height: 150)
            //                    .clipShape(Circle())
            //                    .overlay(Circle().stroke(Color.white, lineWidth: 4)) as! Image
            //            }
        }
    }
}

//struct NewListView_Previews: PreviewProvider {
//    @State var b: Bool = true
//    static var previews: some View {
//        NewListView(viewModel: NewListViewModel(), listTitle: "", shouldPopToRootView: $b)
//        .environment(\.colorScheme, .dark)
//    }
//}

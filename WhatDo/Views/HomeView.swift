//
//  ContentView.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/20/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var isActive: Bool = false
    @State var isExistingActive: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink(destination: viewModel.newListView, isActive: self.$isActive) {
                    Text("New List")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .padding(10)
                }
                NavigationLink(destination: ExistingListsView(isActive: self.$isExistingActive), isActive: $isExistingActive) {
                    Text("My Lists")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .padding(10)
                }
            }
            .onAppear{
                self.viewModel.fetchLists()
            }
            .onDisappear {
                self.viewModel.resetNewListView(isActive: self.$isActive)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
        .environment(\.colorScheme, .dark)
    }
}

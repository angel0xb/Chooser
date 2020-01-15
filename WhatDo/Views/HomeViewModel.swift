//
//  HomeViewModel.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/20/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//
import CoreData
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published private(set) var items: [ListItem] = []
    @Published private(set) var itemImages = [ListItem:UIImage]()
    @Published var newListView: NewListView?
    @Published var existingListsView: ExistingListsView?
    
    init() {
//        deleteAllData()
    }
    func deleteAllData(){
        CoreDataHelper.shared.deleteAllItems()
        CoreDataHelper.shared.deleteAllLists()
    }
    
    func fetchLists() {
        CoreDataHelper.shared.fetchAllLists()
    }
    
    func resetExisingListView(isActive: Binding<Bool>) {
        existingListsView = ExistingListsView(isActive: isActive)
    }
    
    func resetNewListView(isActive: Binding<Bool>)  {
        newListView = NewListView(viewModel: NewListViewModel(isEditing: false), shouldPopToRootView: isActive)
    }
}

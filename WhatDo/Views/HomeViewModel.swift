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
    @Published var existingListView: ExistingListsView?
    
    init() {
//        deleteAllData()
    }
    func deleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "AList"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    
    func resetExisingListView(isActive: Binding<Bool>) {
        existingListView = ExistingListsView(isActive: isActive)
    }
    
    func resetNewListView(isActive: Binding<Bool>)  {
        newListView = NewListView(viewModel: NewListViewModel(isEditing: false), shouldPopToRootView: isActive)
    }
    
}

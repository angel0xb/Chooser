//
//  ExistingListViewModel.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/31/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//

import UIKit
import Combine
import CoreData

class ExistingListsViewModel: ObservableObject {
    @Published var lists: [AList] = []
    
    init() {
        DispatchQueue.main.async {
            self.retrieveLists()
        }
    }
    
    func deleteList(at offsets: IndexSet) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var listsCopy = Set(lists)
        lists.remove(atOffsets: offsets)
        listsCopy.subtract(Set(lists))
        guard let listToDelete = listsCopy.first else { return }
        managedContext.delete(listToDelete)
        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveLists() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "AList")
        
        do {
            print("Fecthing....")
            lists = try managedContext.fetch(fetchRequest) as! [AList]
            
            //remove list if it has no items
            let listsToBeDeleted = lists.filter { $0.items.isEmpty }
            
            for list in listsToBeDeleted {
                managedContext.delete(list)
            }
            
            //save updated context
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

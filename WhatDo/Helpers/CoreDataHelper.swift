//
//  CoreDataHelper.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 1/13/20.
//  Copyright © 2020 AngelRodriguez. All rights reserved.
//

import CoreData
import SwiftUI

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    var shouldFetch: Bool = true
    var lists = [AList]()
    
    init() {
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        fetchAllLists()
    }
    
    //maybe move this into a NSManagedObj Extension
    func getEntityDescription(for entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
    }
    
    func getManagedObject(from entity: NSEntityDescription) -> NSManagedObject {
        return NSManagedObject(entity: entity, insertInto: managedContext)
    }
    
    func fetchAllLists() {
        var lists: [AList] = []
        if shouldFetch {
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
                saveContext()
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            shouldFetch = false
            self.lists = lists.filter{ !$0.items.isEmpty}
        }
    }
    
    func saveContext() {
        do {
            shouldFetch = true
            try managedContext.save()
        } catch let error as NSError {
            shouldFetch = false
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete(item: NSManagedObject) {
        managedContext.delete(item)
        saveContext()
    }
    
    func deleteAllLists() {
        let deleteAllListsReq = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "AList"))
        do {
            try managedContext.execute(deleteAllListsReq)
        }
        catch {
            print(error)
        }
    }
    
    func deleteAllItems() {
        let deleteAllItemsReq = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "ListItem"))
        do {
            try managedContext.execute(deleteAllItemsReq)
        }
        catch {
            print(error)
        }
    }
}

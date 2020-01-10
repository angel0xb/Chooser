//
//  NewListViewModel.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/20/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

class NewListViewModel: ObservableObject {
    @Published var listTitle: String = ""
    @Published var items: Set<ListItem> = []
    @Published private(set) var itemImages = [ListItem:UIImage]()
    @State var isEditing: Bool = false
    private var editList: AList?//used for editiing a list

    init() {
       
    }
    init(isEditing: Bool) {
        self.isEditing = isEditing
    }
    
    init(list: AList, isEditing: Bool) {
        self.editList = list
        self.listTitle = list.title
        self.items = list.items
        self.isEditing = isEditing
    }
    
    func addItem(title: String, info: String, img: UIImage = UIImage()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let itemEntity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedContext)!
        let item = ListItem(entity: itemEntity, insertInto: managedContext)
        item.title = title
        item.info = info

        items.insert(item)
        print("items:\(items)\n\n\n")
    }
    
    func deleteItem(at offsets: IndexSet) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var itemsCopy = items
        var array = Array(items)
        array.remove(atOffsets: offsets)
        items = Set(array)
        itemsCopy.subtract(Set(array))
        guard let itemToDelete = itemsCopy.first else {return}
        
        managedContext.delete(itemToDelete)
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
        
    func saveList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let listEntity = NSEntityDescription.entity(forEntityName: "AList", in: managedContext)!
        let list = !isEditing ? NSManagedObject(entity: listEntity,insertInto: managedContext) : NSManagedObject(entity: editList!.entity, insertInto: managedContext)
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        for item in items {
            item.setValue(list, forKey: "list")
        }

        list.setValue(listTitle, forKeyPath: "title")
        list.setValue(items, forKey: "items")
        
        
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchImage(for item: ListItem) {
        guard case .none = itemImages[item] else { return }
        //        guard let data = URL(string: item.imgData) else { return }
        
        //        AF.request(url).response { response in
        //            let image = response.map{ UIImage(data:$0 ?? Data())}
        //            self.cardImages[card] = image.value ?? UIImage()
        //        }
    }
    
}

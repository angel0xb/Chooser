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
    @Published var isEditing: Bool = false
    private var editList: AList?//used for editiing a list

    init() {
       
    }
    init(isEditing: Bool) {
        self.isEditing = isEditing
    }
    
    init(list: AList, isEditing: Bool) {
        self.isEditing = isEditing
        self.editList = list
        self.listTitle = list.title
        self.items = list.items
    }
    
    func addItem(title: String, info: String, img: UIImage = UIImage()) {
        let itemEntity = CoreDataHelper.shared.getEntityDescription(for: "ListItem")
        let item = CoreDataHelper.shared.getManagedObject(from: itemEntity) as! ListItem
        item.title = title
        item.info = info

        items.insert(item)
//        print("items:\(items)\n\n\n")
    }
    
    func deleteItem(at offsets: IndexSet) {        
        var itemsCopy = items
        var array = Array(items)
        array.remove(atOffsets: offsets)
        items = Set(array)
        itemsCopy.subtract(Set(array))
        guard let itemToDelete = itemsCopy.first else {return}
        
        CoreDataHelper.shared.delete(item: itemToDelete)
    }
        
    func saveList() {
        
        let listEntity = CoreDataHelper.shared.getEntityDescription(for: "AList")
        let list = !isEditing ? CoreDataHelper.shared.getManagedObject(from: listEntity) : CoreDataHelper.shared.getManagedObject(from: editList!.entity)
        
        for item in items {
            item.setValue(list, forKey: "list")
        }

        list.setValue(listTitle, forKeyPath: "title")
        list.setValue(items, forKey: "items")
        
        CoreDataHelper.shared.saveContext()
    }
    
    func getNavBarTitle() -> String {
        return isEditing ? "Editing List:" : "New List:"
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

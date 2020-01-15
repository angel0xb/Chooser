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
    @Published var lists: [AList] = CoreDataHelper.shared.lists
    
    func deleteList(at offsets: IndexSet) {
        
        var listsCopy = Set(lists)
        lists.remove(atOffsets: offsets)
        listsCopy.subtract(Set(lists))
        guard let listToDelete = listsCopy.first else { return }
        
        CoreDataHelper.shared.delete(item: listToDelete)
    }
}

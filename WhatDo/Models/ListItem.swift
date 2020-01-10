//
//  ListItem.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/20/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//

import CoreData

class ListItem: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var info: String
    @NSManaged var imgData: Data
    @NSManaged var list: AList
//    fileprivate(set) var id: UUID = UUID()
}

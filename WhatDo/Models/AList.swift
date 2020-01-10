//
//  List.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 12/20/19.
//  Copyright © 2019 AngelRodriguez. All rights reserved.
//

import CoreData

class AList: NSManagedObject {
    @NSManaged fileprivate(set) var title: String
    @NSManaged var items: Set<ListItem>
}

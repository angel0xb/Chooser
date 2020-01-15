//
//  NewItemViewModel.swift
//  WhatDo
//
//  Created by Angel Rodriguez on 1/15/20.
//  Copyright © 2020 AngelRodriguez. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class NewItemViewModel: ObservableObject {
        @State var items: Set<ListItem> = []
    
        func addItem(title: String, info: String, img: UIImage = UIImage()) {
            
            let itemEntity = CoreDataHelper.shared.getEntityDescription(for: "ListItem")
            let item = CoreDataHelper.shared.getManagedObject(from: itemEntity) as! ListItem
            item.title = title
            item.info = info
            if let data = img.pngData() {
                item.imgData = data
            }
            items.insert(item)
        }
}

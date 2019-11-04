//
//  Item.swift
//  Todoey
//
//  Created by Seif Yousry on 10/30/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

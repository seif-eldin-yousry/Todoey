//
//  Category.swift
//  Todoey
//
//  Created by Seif Yousry on 10/30/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}

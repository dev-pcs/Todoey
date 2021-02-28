//
//  Item.swift
//  Todoey
//
//  Created by Priyank Shah on 8/13/20.
//  Copyright © 2020 Shah Priyank. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String    = ""
    @objc dynamic var done  : Bool      = false
    @objc dynamic var dateCreated: Date?
    var parentCategory      = LinkingObjects(fromType: Category.self, property: "items")     //reverse Relationship
}

//
//  Category.swift
//  Todoey
//
//  Created by Priyank Shah on 8/13/20.
//  Copyright © 2020 Shah Priyank. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {                        //object is needed for saving realm objects
    @objc dynamic var name: String = ""         //to update data dynamically
    let items = List<Item>()                    //forward relationship
}

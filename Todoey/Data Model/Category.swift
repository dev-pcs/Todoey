//
//  Category.swift
//  Todoey
//
//  Created by Priyank Shah on 8/13/20.
//  Copyright © 2020 Shah Priyank. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()        //forward relationship
}

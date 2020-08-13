//
//  Data.swift
//  Todoey
//
//  Created by Priyank Shah on 8/12/20.
//  Copyright © 2020 Shah Priyank. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""       //dynamically update changes
    @objc dynamic var age: Int = 0
}

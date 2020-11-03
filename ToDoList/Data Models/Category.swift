//
//  Category.swift
//  ToDoList
//
//  Created by Ehab Osama on 10/16/20.
//  Copyright © 2020 Ehab. All rights reserved.
//


import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var color:String = ""
    var items = List<Item>()
}

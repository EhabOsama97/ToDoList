//
//  Item.swift
//  ToDoList
//
//  Created by Ehab Osama on 10/16/20.
//  Copyright © 2020 Ehab. All rights reserved.
//


import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var date:Date?
    @objc dynamic var done:Bool = false
    @objc dynamic var color:String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

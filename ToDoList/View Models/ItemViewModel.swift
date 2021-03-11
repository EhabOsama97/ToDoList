//
//  ItemViewModel.swift
//  ToDoList
//
//  Created by Ehab Osama on 3/11/21.
//  Copyright © 2021 Ehab. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class ItemViewModel {
    
    let realm = try! Realm()
    var ArrayOfItems:Results<Item>?
    var parentCategory:Category?
    var reloadTableViewClosure: (()->())?
    
    func initFetch() {
        ArrayOfItems = parentCategory?.items.sorted(byKeyPath: "date", ascending: true)
        self.reloadTableViewClosure?()
    }
    
    var numberOfItems: Int? {
        return ArrayOfItems!.count
    }
    func getItemCellModel( at indexPath: IndexPath ) -> Item? {
        return ArrayOfItems![indexPath.row]
    }
    
    func itemPressed(indexPath: IndexPath ){
        if let item = ArrayOfItems?[indexPath.row] {
            do{
                try realm.write{
                item.done = !item.done
                }
                }
            catch{
                print("error in selected cell \(error)")
            }
            self.reloadTableViewClosure?()
            
        }
    }
    
    func deleteItem(indexPath : IndexPath) {
        if let deletedItem = ArrayOfItems?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(deletedItem)
                }
            }catch{
                print("error in deleting item")
            }
        }
        
    }
    
    func addItem(name:String) {
        
        do{
            try self.realm.write{
                let newItem = Item()
                newItem.name = name
                newItem.date = Date()
                self.parentCategory?.items.append(newItem)
            }
            
        }catch {
            print("error in add new item \(error)" )
        }
        self.reloadTableViewClosure?()
    }
}

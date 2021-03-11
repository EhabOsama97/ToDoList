//
//  CategoryViewModel.swift
//  ToDoList
//
//  Created by Ehab Osama on 3/11/21.
//  Copyright © 2021 Ehab. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class CategoryViewModel {
    
    let realm = try! Realm()
    var ArrayOfCategory:Results<Category>?
    private var categories: [Category] = [Category]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var newCategoryName:String = String() {
        didSet {
            do{try self.realm.write {
                let newCategory = Category()
                newCategory.name = newCategoryName
                newCategory.color = RandomFlatColor().hexValue()
                categories.append(newCategory)
                self.SaveData(newCategory: newCategory)
                print("hy3ml reload table view closure")
                self.reloadTableViewClosure?()
                print("3ml ")
                
                } }catch{
                    print("error in saving Category \(error)")
            }
           
        }
    }
   
    var reloadTableViewClosure: (()->())?
    
    func initFetch() {
        ArrayOfCategory = realm.objects(Category.self)
        categories = (ArrayOfCategory?.toArray())!
    }
    
    var numberOfCategory: Int {
        return categories.count
    }
    
    func getCategoryCellModel( at indexPath: IndexPath ) -> Category {
        return categories[indexPath.row]
    }
    func deleteCategory(indexpath : IndexPath) {
        let deletedCategory = categories[indexpath.row]
        do {
            try self.realm.write{
                self.realm.delete(deletedCategory)
                self.categories.remove(at: indexpath.row)
            }
        }catch{
            print("error icc deleted category \(error)")
        }
        self.reloadTableViewClosure?()
    }
    func SaveData(newCategory :Category) {
        self.realm.add(newCategory)
    }
}


extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }

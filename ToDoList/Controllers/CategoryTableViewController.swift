//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Ehab Osama on 10/16/20.
//  Copyright © 2020 Ehab. All rights reserved.
//


import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    let realm = try! Realm()
    var ArrayOfCategory:Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        print(Realm.Configuration.defaultConfiguration.fileURL)
        LoadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.navigationBar.backgroundColor = UIColor(hexString: "1D9BF6")
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: "1D9BF6")!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: "1D9BF6")!, returnFlat: true)]
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayOfCategory!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = ArrayOfCategory![indexPath.row].name
        let color = UIColor(hexString: (ArrayOfCategory?[indexPath.row].color)!)
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "ShowItemsSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemsTableViewController
        destination.parentCategory = ArrayOfCategory![tableView.indexPathForSelectedRow!.row]
    }
  
    //MARK: - add category button pressed
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alert.addTextField { Alerttextfield in
            Alerttextfield.placeholder = " Category Name"
            textfield = Alerttextfield
        }
        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: { acion in
            do{try self.realm.write {
                let newCategory = Category()
                newCategory.name = textfield.text!
                newCategory.color = RandomFlatColor().hexValue()
                self.SaveData(newCategory: newCategory)
                } }catch{
                    print("error in saving Category \(error)")
            }
            
        }))
        present(alert,animated: true,completion: nil)
        
    }
    
    //MARK: - load Data
    func LoadData() {
        ArrayOfCategory = realm.objects(Category.self)
        tableView.reloadData()
    }
    //MARK: - Save Data
    func SaveData(newCategory :Category) {
        self.realm.add(newCategory)
        self.tableView.reloadData()
    }
}
extension CategoryTableViewController:SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let deletedCategory = self.ArrayOfCategory?[indexPath.row]{
                do {
                    try self.realm.write{
                        self.realm.delete(deletedCategory)
                    }
                }catch{
                    print("error icc deleted category \(error)")
                }
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
        
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
}

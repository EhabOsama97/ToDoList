//
//  ItemsTableViewController.swift
//  ToDoList
//
//  Created by Ehab Osama on 10/17/20.
//  Copyright © 2020 Ehab. All rights reserved.
//


import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit
class ItemsTableViewController: UITableViewController {

    let realm = try! Realm()
    var arrayOfItems:Results<Item>?
    var parentCategory:Category? {
        didSet{
        loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        

      
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: parentCategory!.color)
        title = parentCategory?.name
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: parentCategory!.color)!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: parentCategory!.color)!, returnFlat: true)]
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayOfItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        if let item = arrayOfItems?[indexPath.row] {
            cell.textLabel?.text = item.name
            let color = UIColor(hexString: parentCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(arrayOfItems!.count)))
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
            if (item.done) {
                cell.accessoryType = .checkmark
                print("item done")
            }else{
                cell.accessoryType = .none
                print("item not done")
            }
        } else{
            cell.textLabel?.text = "No Items"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = arrayOfItems?[indexPath.row] {
            do{
                try realm.write{
                item.done = !item.done
                }
                }
            catch{
                print("error in selected cell \(error)")
            }
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    @IBAction func AddItemButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message:"", preferredStyle: .alert)
        alert.addTextField { (alertText) in
            alertText.placeholder = " add Item"
            textfield = alertText
        }
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
           
            do{
                try self.realm.write{
            let newItem = Item()
                newItem.name = textfield.text!
                newItem.date = Date()
                    self.parentCategory?.items.append(newItem)
                }
                
            }catch {
                print("error in add new item \(error)" )
            }
                self.tableView.reloadData() }
                
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
        
            
    }
    
    //MARK: - Load Data
    func loadData() {
        arrayOfItems = parentCategory?.items.sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }


}
//MARK: - Swipe Cell Models
extension ItemsTableViewController:SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let deletedItem = self.arrayOfItems?[indexPath.row] {
            do{
                try self.realm.write{
                    self.realm.delete(deletedItem)
                }
            }catch{
                print("error in deleting item")
            }
        }
        }
        deleteAction.image = UIImage(named: "delete")
        return[deleteAction]
    }
 
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
           var options = SwipeOptions()
           options.expansionStyle = .destructive
           //options.transitionStyle = .border
           return options
       }
    
}

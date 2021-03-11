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

    lazy var viewModel: ItemViewModel = {
        return ItemViewModel()
    }()
    
    
    let realm = try! Realm()
    var arrayOfItems:Results<Item>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationController()
    }

    func initView() {
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    func initNavigationController () {
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: viewModel.parentCategory!.color)
        title = viewModel.parentCategory?.name
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: viewModel.parentCategory!.color)!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: viewModel.parentCategory!.color)!, returnFlat: true)]
    }
    func initVM() {
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                print("init reload table view closure")
                self?.tableView.reloadData()
            }
        }
        viewModel.initFetch()

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItems ?? 1 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        if let item = viewModel.getItemCellModel(at: indexPath) {
            
            cell.textLabel?.text = item.name
            let color = UIColor(hexString: viewModel.parentCategory!.color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(viewModel.numberOfItems!)))
            
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
     
        viewModel.itemPressed(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func AddItemButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Item", message:"", preferredStyle: .alert)
        alert.addTextField { (alertText) in
            alertText.placeholder = " add Item"
            textfield = alertText
        }
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            let name = textfield.text!
            self.viewModel.addItem(name: name)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
        
            
    }


}
//MARK: - Swipe Cell Models
extension ItemsTableViewController:SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.viewModel.deleteItem(indexPath: indexPath)
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

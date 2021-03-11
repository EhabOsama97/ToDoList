//
//  CategoryTableViewController.swift
//  ToDoList
//
//  Created by Ehab Osama on 10/16/20.
//  Copyright © 2020 Ehab. All rights reserved.
//


import UIKit
import ChameleonFramework
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    var IIndexPath:IndexPath?
    
    lazy var viewModel: CategoryViewModel = {
        return CategoryViewModel()
    }()
    
    lazy var itemViewModel: ItemViewModel = {
        return ItemViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        initView()
        initVM()
    }
    override func viewWillAppear(_ animated: Bool) {
         initViewColor()
    }
    
    func initView() {
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "categoryTableViewCell", bundle: .main), forCellReuseIdentifier: "categoryTableViewCell")
    }
    func initViewColor () {
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "1D9BF6")
       navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: "1D9BF6")!, returnFlat: true)
       navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: "1D9BF6")!, returnFlat: true)]
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
        return viewModel.numberOfCategory
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! categoryTableViewCell
        cell.delegate = self
        let categoryModel = viewModel.getCategoryCellModel( at: indexPath )
        let color = UIColor(hexString: (categoryModel.color))
        cell.configure(Name: categoryModel.name, color: color!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        IIndexPath = indexPath
        performSegue(withIdentifier: "ShowItemsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemsTableViewController
        itemViewModel.parentCategory = viewModel.getCategoryCellModel(at: IIndexPath!)
        destination.viewModel = itemViewModel
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
         
            self.viewModel.newCategoryName = textfield.text!            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        present(alert,animated: true,completion: nil)
        
    }
    
}

extension CategoryTableViewController:SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
                self.viewModel.deleteCategory(indexpath : indexPath)
            
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

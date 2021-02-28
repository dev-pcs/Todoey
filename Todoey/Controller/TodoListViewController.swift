//
//  ViewController.swift
//  Todoey
//
//  Created by Priyank Shah on 8/11/20.
//  Copyright © 2020 Shah Priyank. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory: Category? {
        didSet{
            loadItems()     //do this when the vlaue is set to new value
            tableView.separatorStyle = .none
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let coloHex = selectedCategory?.color {
            title = selectedCategory!.name
            guard let navbar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist ")
            }
            
            if let navBarColor = UIColor(hexString: coloHex) {
                navbar.barTintColor = navBarColor
                navbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                searchBar.barTintColor = navBarColor
                navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            }
            
            
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:(CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            cell.accessoryType = item.done == true ? .checkmark : .none     
        }else {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField       = UITextField()
        
        let alert           = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        let action          = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen when add is clicked
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem     = Item()
                        newItem.title   = textField.text!
                        newItem.dateCreated    = Date()
                        currentCategory.items.append(newItem)
                        print(newItem.dateCreated)
                    }
                }catch {
                    print("error saving new item \(error)")
                }
            }
            self.tableView.reloadData()            //            self.saveItems()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Model manipulation method
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }catch {
                print("error deleting item \(error)")
            }
        }
    }
}



//MARK: - Searchbar methods


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}





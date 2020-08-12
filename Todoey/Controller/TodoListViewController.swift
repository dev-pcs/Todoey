//
//  ViewController.swift
//  Todoey
//
//  Created by Priyank Shah on 8/11/20.
//  Copyright © 2020 Shah Priyank. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none     //ternary operator
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done  //checkmark toggle
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField       = UITextField()
        
        let alert           = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        let action          = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen when add is clicked
            let newItem     = Item()
            newItem.title   = textField.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Model manipulation method
    
    func saveItems() {
        let encoder     = PropertyListEncoder()
        do{
            let data    = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("error encoding data\(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItems() {
        if let data         = try? Data(contentsOf: dataFilePath!) {
            let decoder     = PropertyListDecoder()
            do{
                itemArray   = try decoder.decode([Item].self, from: data)
            }catch {
                print("error decoding data\(error)")
            }
        }
    }
}




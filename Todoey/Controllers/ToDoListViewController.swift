//
//  ViewController.swift
//  Todoey
//
//  Created by Seif Yousry on 10/23/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //comment intialization of items because it's already saved in the plist with all the data
//        let newItem = Item()
//        newItem.title = "First item"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Second item"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Third item"
//        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        print(dataFilePath!)
        
        loadItems()
        
    }
    
    //MARK - TableView Data source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Ternary Operator ==>
        // value = condition ? value if true : value if false
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        //above line = if-else statment below
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row].title)
        //print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //the above line is the same if-else statment down
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to-do item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user clicks add button in alert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
//            self.itemArray.append(textField.text!)
            self.saveItems()
            
            
            self.tableView.reloadData()
            print("Success")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
//            print(alertTextField.text)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK -- Model Manipulation methods
    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding items \(error)")
            }
        }
    }
    
}




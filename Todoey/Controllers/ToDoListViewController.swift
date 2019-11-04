//
//  ViewController.swift
//  Todoey
//
//  Created by Seif Yousry on 10/23/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
        
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
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
        
        //loadItems()
        
    }
    
    //MARK: - TableView Data source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            //Ternary Operator ==>
            // value = condition ? value if true : value if false
            cell.accessoryType = todoItems?[indexPath.row].done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no item added"
        }
        
        
        //above line = if-else statment below
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row].title)
        //print(indexPath.row)
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating items \(error)")
            }
        }
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//        saveItems()
        
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
    
    //MARK: - Add New Items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to-do item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user clicks add button in alert
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("Error saving items \(error)")
                }
            }
            
            
//            let newItem = Item(context: self.context)
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            newItem.title = textField.text!
//            self.itemArray.append(newItem)
            
//            self.itemArray.append(textField.text!)
            //self.saveItems()
            
            
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
    
    //MARK: - Model Manipulation methods
//    func saveItems () {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving items \(error)")
//        }
//    }
    
    func saveItems(items : Item){
        do {
            try realm.write {
                realm.add(items)
            }
        } catch {
            print("Error saving items \(error)")
        }
        
    }
    
    func loadItems() {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        //request.predicate = compundPredicate
//        //let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching \(error)")
//        }
        tableView.reloadData()
    }
    
}

//MARK:- Search Bar Methods
extension ToDoViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //shortening code
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
//        let request :NSFetchRequest = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        //loadItems(with: request, predicate: predicate)
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching \(error)")
//        }
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


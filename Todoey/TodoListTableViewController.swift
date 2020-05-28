//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Furqan on 28/05/2020.
//  Copyright © 2020 Furqan. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggs", "Destory Car"]
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = defaults.array(forKey: "TodoItemArray") as? [String]{
            itemArray = item
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("SUccess")
            print(textField.text!)
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoItemArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

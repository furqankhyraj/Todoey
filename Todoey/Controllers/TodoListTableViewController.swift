//
//  TodoListTableViewController.swift
//  Todoey
//
//  Created by Furqan on 28/05/2020.
//  Copyright © 2020 Furqan. All rights reserved.
//

import UIKit
import CoreData
class TodoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType =  item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //Code For Deleting Item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("errr saving context \(error)")
        }
        self.tableView.reloadData()
    }
     
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error Fetching Data \(error)")
        }
        tableView.reloadData()
        
    }
}

extension TodoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("In FUnc")
        print(searchBar.text!)
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }

}

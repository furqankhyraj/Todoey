//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Furqan on 29/05/2020.
//  Copyright © 2020 Furqan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [CategoryList]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

    func loadCategories(with request: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error Fetching Data \(error)")
        }
        tableView.reloadData()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("SUccess")
            print(textField.text!)

            let newCategory = CategoryList(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)

            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
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
}

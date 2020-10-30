//
//  ViewController.swift
//  Todoey
//
//  Created by Timur Kaldybek on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    // btwn SQLite and application
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
//MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
//MARK: - Ternary Opertor
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    // Select Row
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
      
//        context.delete(itemArray[indexPath.row])
//       itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { [self] (action) in
            
// what will happen when user clicks on button
            // NSManagedObject - горизонтальное поле в таблице (newItem)
            let newItem = Item(context: context)
            newItem.title = textField.text!
            newItem.done = false
            if newItem.title != "" {
            self.itemArray.append(newItem)
            self.saveItems()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manipulation Methods
    func saveItems(){
        do{
            try self.context.save()
        } catch {
            print("Error ", error)
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
          itemArray = try context.fetch(request)
        } catch {
            print("Error in fetching items \(error)")
        }
    }
}

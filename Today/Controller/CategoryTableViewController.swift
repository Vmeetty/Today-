//
//  CategoryTableViewController.swift
//  Today
//
//  Created by user on 22.04.2022.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(realm.configuration.fileURL)
        manager.loadCategories(categoty: Category.self) { results in
            categories = results
        }
        tableView.rowHeight = 70
        
    }

   
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let textFieldText = alert.textFields![0].text {
                let newCategory = Category()
                newCategory.name = textFieldText
                
                self.manager.saveItems(realmObjectClass: newCategory)
                self.tableView.reloadData()
                
            }
        }
        alert.addAction(action)
        alert.addTextField { textField in
            textField.placeholder = "Type your category"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellID, for: indexPath) as! SwipeTableViewCell
        var content = cell.defaultContentConfiguration()
        content.text = categories?[indexPath.row].name ?? "No categories yet"
        cell.contentConfiguration = content
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as! TodayViewController
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}

extension CategoryTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let category = self.categories?[indexPath.row] {
                do {
                    try self.realm.write({
                        self.realm.delete(category)
                    })
                } catch {
                    print("Error of deliting realm object: \(error)")
                }
                self.tableView.reloadData()
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
}

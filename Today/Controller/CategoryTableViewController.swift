//
//  CategoryTableViewController.swift
//  Today
//
//  Created by user on 22.04.2022.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(realm.configuration.fileURL)
        manager.loadCategories(categoty: Category.self) { results in
            categories = results
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

   
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let textFieldText = alert.textFields![0].text {
                let newCategory = Category()
                newCategory.name = textFieldText
                newCategory.color = UIColor.randomFlat().hexValue()
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = categories?[indexPath.row].name ?? "No categories yet"
        guard let hexColor = UIColor(hexString: categories![indexPath.row].color) else {
            fatalError("have no hexcolor")
        }
        content.textProperties.color = ContrastColorOf(hexColor, returnFlat: true)
        cell.backgroundColor = hexColor
        cell.contentConfiguration = content
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as! TodayViewController
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(category)
                })
            } catch {
                print("Error of deliting realm object: \(error)")
            }
        }
    }
    
}


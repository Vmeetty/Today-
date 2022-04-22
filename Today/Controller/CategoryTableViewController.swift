//
//  CategoryTableViewController.swift
//  Today
//
//  Created by user on 22.04.2022.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }

   
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let textFieldText = alert.textFields![0].text {
                let newCategory = Category(context: self.context)
                newCategory.name = textFieldText
                
                self.categories.append(newCategory)
                self.saveCategory()
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
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = categories[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as! TodayViewController
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
           print("Saving context failed: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Fetching context failed: \(error)")
        }
    }
    
}

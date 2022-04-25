//
//  ViewController.swift
//  Today
//
//  Created by user on 17.04.2022.
//

import UIKit
import CoreData

class TodayViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.nibCellName, bundle: nil), forCellReuseIdentifier: K.nibCellID)
        
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let textItem = alert.textFields![0].text {
                
                let newItem = Item(context: self.context)
                newItem.title = textItem
                newItem.done = false
                newItem.category = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Creat item"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.nibCellID, for: indexPath) as! ItemTableViewCell
        cell.textItemLabel.text = itemArray[indexPath.row].title
        let doneStatus = itemArray[indexPath.row].done
        cell.accessoryType = doneStatus ? .checkmark : .none
        cell.delegate = self
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func saveItems() {
        do {
            try context.save()
            print("saved in CoreData")
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(text: String? = nil) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var predicate = NSPredicate()
        
        if let text = text {
            predicate = NSPredicate(format: "category.name MATCHES %@ AND title CONTAINS[cd] %@",
                                    argumentArray: [selectedCategory!.name!, text])
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        } else {
            predicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        }
        request.predicate = predicate
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error of fetching request \(error)")
        }
        tableView.reloadData()
    }
    
}

extension TodayViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            loadItems(text: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
}

extension TodayViewController: ItemTableViewCellDelegate {
    
    func setToSerious(_ cell: ItemTableViewCell) -> UIImage? {
        var image = ""
        image = cell.starButton.imageView?.image == UIImage(systemName: "star") ? "star.fill" : "star"
        return UIImage(systemName: image)
    }
    
}









































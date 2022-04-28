//
//  ViewController.swift
//  Today
//
//  Created by user on 17.04.2022.
//

import UIKit
import RealmSwift

class TodayViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var toDoResultes: Results<Item>?
    var manager = DataManager()
    
    var selectedCategory: Category? {
        didSet {
            if let category = selectedCategory {
                manager.delegate = self
                manager.loadItemsWith(item: Item.self, itemCategory: category)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.nibCellName, bundle: nil), forCellReuseIdentifier: K.nibCellID)
        
    }
    
//MARK: - Create new item
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let textItem = alert.textFields![0].text {
                if let category = self.selectedCategory {
                    do {
                        try self.realm.write({
                            let newItem = Item()
                            newItem.title = textItem
                            newItem.dateCreated = Date()
                            category.items.append(newItem)
                        })
                    } catch {
                        print("Error of write new items in TodayViewController: \(error)")
                    }
                }
                
                self.tableView.reloadData()
                
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Creat item"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
 //MARK: - DataSource & Delegate section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoResultes?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.nibCellID, for: indexPath) as! ItemTableViewCell
        if let item = toDoResultes?[indexPath.row] {
            cell.textItemLabel.text = item.title
            let doneStatus = item.done
            cell.accessoryType = doneStatus ? .checkmark : .none
            cell.indexPathForStar = indexPath
            
            let serious = item.serious
            let image = serious ? "star.fill" : "star"
            cell.starButton.setImage(UIImage(systemName: image), for: .normal)
            cell.delegate = self
        } else {
            cell.textItemLabel.text = "No items yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manager.updateDoneStatus(item: toDoResultes?[indexPath.row])
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
//        toDoResultes[indexPath.row].done = !toDoResultes[indexPath.row].done
//        manager.saveItems()
    }
        
}


//MARK: - Extensions

extension TodayViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            toDoResultes = manager.filterItemsBy(toDoResultes, with: searchText)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            manager.loadItemsWith(item: Item.self, itemCategory: selectedCategory)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
}

extension TodayViewController: ItemTableViewCellDelegate {
    
    func setToSerious(_ cell: ItemTableViewCell, didSelectStarButtonAt indexPath: IndexPath) {
        manager.updateSeriousStatus(item: toDoResultes?[indexPath.row])
        tableView.reloadData()
//        toDoResultes[indexPath.row].serious = !toDoResultes[indexPath.row].serious
//        manager.saveItems()
    }
    
}

extension TodayViewController: DataManagerDelegate {
    
    func didLoadedItemsWith(fetchResult: Results<Item>) {
        toDoResultes = fetchResult
        tableView.reloadData()
    }
    
}








































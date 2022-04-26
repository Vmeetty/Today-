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
    var manager = DataManager()
    
    var selectedCategory: Category? {
        didSet {
            manager.delegate = self
            manager.loadItemsWith(itemCategory: selectedCategory)
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.nibCellName, bundle: nil), forCellReuseIdentifier: K.nibCellID)
        
    }
    
//MARK: - Create new item
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let textItem = alert.textFields![0].text {
                
                let newItem = Item(context: self.context)
                newItem.title = textItem
                newItem.done = false
                newItem.category = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.manager.saveItems()
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.nibCellID, for: indexPath) as! ItemTableViewCell
        cell.textItemLabel.text = itemArray[indexPath.row].title
        let doneStatus = itemArray[indexPath.row].done
        cell.accessoryType = doneStatus ? .checkmark : .none
        cell.indexPathForStar = indexPath
        
        let serious = itemArray[indexPath.row].serious
        let image = serious ? "star.fill" : "star"
        cell.starButton.setImage(UIImage(systemName: image), for: .normal)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        manager.saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
}


//MARK: - Extensions

extension TodayViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            manager.loadItemsWith(textFieldText: searchText, itemCategory: selectedCategory)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            manager.loadItemsWith(itemCategory: selectedCategory)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
}

extension TodayViewController: ItemTableViewCellDelegate {
    
    func setToSerious(_ cell: ItemTableViewCell, didSelectStarButtonAt indexPath: IndexPath) {
        itemArray[indexPath.row].serious = !itemArray[indexPath.row].serious
        manager.saveItems()
        tableView.reloadData()
    }
    
}

extension TodayViewController: DataManagerDelegate {
    func didLoadedItemsWith(fetchResult: [Item]) {
        itemArray = fetchResult
        tableView.reloadData()
    }
}








































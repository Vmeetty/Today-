//
//  SeriousTableViewController.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import UIKit
import CoreData

class SeriousTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    let manager = DataManager.shared
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    var predicate = NSPredicate(format: "serious = true")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.nibCellName, bundle: nil), forCellReuseIdentifier: K.nibCellID)
        manager.delegate = self
        
        manager.loadItemsWith(predicate)

    }
    
    

    // MARK: - Table view data source

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
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
  
}

//MARK: - Extensions

extension SeriousTableViewController: ItemTableViewCellDelegate {
    func setToSerious(_ cell: ItemTableViewCell, didSelectStarButtonAt indexPath: IndexPath) {
        itemArray[indexPath.row].serious = !itemArray[indexPath.row].serious
        manager.saveItems()
        manager.loadItemsWith(predicate)
    }
}

extension SeriousTableViewController: DataManagerDelegate {
    func didLoadedItemsWith(fetchResult: [Item]) {
        itemArray = fetchResult
        tableView.reloadData()
    }
}

//
//  SeriousTableViewController.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import UIKit
import RealmSwift

class SeriousTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var itemArray: Results<Item>?
    var manager = DataManager()
    var predicate = NSPredicate(format: "serious = true")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.nibCellName, bundle: nil), forCellReuseIdentifier: K.nibCellID)
       
        manager.delegate = self
        
        manager.loadItemsWith(item: Item.self)

    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.nibCellID, for: indexPath) as! ItemTableViewCell
        if let item = itemArray?[indexPath.row] {
            cell.textItemLabel.text = item.title
            let doneStatus = item.done
            cell.accessoryType = doneStatus ? .checkmark : .none
            cell.indexPathForStar = indexPath
            
            let serious = item.serious
            let image = serious ? "star.fill" : "star"
            cell.starButton.setImage(UIImage(systemName: image), for: .normal)
            cell.delegate = self
        } else {
            cell.textItemLabel.text = "No serious ites yet"
        }
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manager.updateDoneStatus(item: itemArray?[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        manager.saveItems()
    }
  
}

//MARK: - Extensions

extension SeriousTableViewController: ItemTableViewCellDelegate {
    func setToSerious(_ cell: ItemTableViewCell, didSelectStarButtonAt indexPath: IndexPath) {
        manager.updateSeriousStatus(item: itemArray?[indexPath.row])
        tableView.reloadData()
//        itemArray[indexPath.row].serious = !itemArray[indexPath.row].serious
//        manager.saveItems()
    }
}

extension SeriousTableViewController: DataManagerDelegate {
    func didLoadedItemsWith(fetchResult: Results<Item>) {
        itemArray = fetchResult
        tableView.reloadData()
    }
}

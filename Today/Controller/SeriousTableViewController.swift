//
//  SeriousTableViewController.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class SeriousTableViewController: SwipeViewController {
    
    let realm = try! Realm()
    var itemArray: Results<Item>?
    var manager = DataManager()
    var uiManager = UIManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: K.nibCellName, bundle: nil), forCellReuseIdentifier: K.nibCellID)
       
        manager.delegate = self
        
        manager.loadItemsWith(item: Item.self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Serious items"
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: K.nibCellID, for: indexPath) as! ItemTableViewCell
        cell = uiManager.settings(cell: cell, items: itemArray, indexPath: indexPath, color: FlatWhite())
        
        cell.itemCellDelegate = self
        cell.delegate = self
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manager.updateDoneStatus(item: itemArray?[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
//MARK: - Deleting section
    override func updateModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write({
                    realm.delete(item)
                })
            } catch {
                print("Error of deleting item: \(error)")
            }
        }
    }
  
}

//MARK: - Extensions

extension SeriousTableViewController: ItemTableViewCellDelegate {
    func setToSerious(_ cell: ItemTableViewCell, didSelectStarButtonAt indexPath: IndexPath) {
        manager.updateSeriousStatus(item: itemArray?[indexPath.row])
        tableView.reloadData()
    }
}

extension SeriousTableViewController: DataManagerDelegate {
    func didLoadedItemsWith(fetchResult: Results<Item>) {
        itemArray = fetchResult
        tableView.reloadData()
    }
}

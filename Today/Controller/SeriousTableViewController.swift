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

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.loadSeriousItems { items in
            if let items = items {
                itemArray = items
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.seriousCellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = itemArray[indexPath.row].title
        cell.contentConfiguration = content
        
        return cell
    }
    
    


}

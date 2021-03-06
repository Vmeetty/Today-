//
//  SwipeViewController.swift
//  Today
//
//  Created by user on 28.04.2022.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let hexColor = UIColor(hexString: K.hexColor) {
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller not exist")
            }
            navBar.backgroundColor = hexColor
            let contastTextColor = ContrastColorOf(hexColor, returnFlat: true)
            navBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contastTextColor]
            navBar.tintColor = contastTextColor
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }


    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    func updateModel(at indexPath: IndexPath) {
      //...
    }
    
}

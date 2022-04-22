//
//  CategoryTableViewController.swift
//  Today
//
//  Created by user on 22.04.2022.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
//    var categories = [Categories]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

   
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            if let textFieldText = alert.textFields![0].text {
//                let newCategory =
            }
        }
        alert.addAction(action)
        alert.addTextField { textField in
            textField.placeholder = "Tipe your category"
        }
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return categories.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //..
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //...
    }
    
}

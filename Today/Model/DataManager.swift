//
//  DataManager.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import Foundation
import CoreData
import UIKit


class DataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let shared = DataManager()
    
    func saveItemsFrom(tableView: UITableView, complition: () -> Void) {
        do {
            try context.save()
            print("saved in CoreData")
        } catch {
            print("Error saving context: \(error)")
        }
//        tableView.reloadData() // в комплишене перезагрузить таблицу
    }
    
    
    
    func loadSeriousItems(complition: ([Item]?) -> Void) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var fetchResult = [Item]()
        var predicate = NSPredicate()
        predicate = NSPredicate(format: "serious = true")
        request.predicate = predicate
        do {
            fetchResult = try context.fetch(request)
        } catch {
            print("Error of fetching request \(error)")
        }
        complition(fetchResult)
//        tableView.reloadData()
    }
    
}


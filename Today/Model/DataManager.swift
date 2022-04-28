//
//  DataManager.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import Foundation
import RealmSwift
import UIKit

protocol DataManagerDelegate {
    func didLoadedItemsWith(fetchResult: Results<Item>)
}


class DataManager {
    
    let realm = try! Realm()
    
    var delegate: DataManagerDelegate?
        
    
    func saveItems(realmObjectClass: Object) {
        do {
            try realm.write({
                realm.add(realmObjectClass)
            })
        } catch {
            print("Error of write new realm object: \(error)")
        }
    }
    
    func updateDoneStatus(item: Item?) {
        if let item = item {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("Fail to update done property realm: \(error)")
            }
        }
    }
    
    func updateSeriousStatus(item: Item?) {
        if let item = item {
            do {
                try realm.write({
                    item.serious = !item.serious
                })
            } catch {
                print("Fail to update serious property realm: \(error)")
            }
        }
    }
    
    
    func loadItemsWith(item: Item.Type, predicate: NSPredicate? = nil, textFieldText: String? = nil, itemCategory: Category? = nil) {

        var results: Results<Item>?
        if let selectedCategory = itemCategory {
            results = selectedCategory.items.sorted(byKeyPath: "dateCreated", ascending: true)
        } else {
            let allItems = realm.objects(item)
            results = allItems.where({
                $0.serious == true
            })
        }
        if let results = results {
            delegate?.didLoadedItemsWith(fetchResult: results)
        }
    }
    
    func loadCategories(categoty: Category.Type, complion: (Results<Category>) -> Void) {
        
        let categories = realm.objects(categoty)
        complion(categories)
        
    }
    
    func filterItemsBy(_ itemsResults: Results<Item>?, with text: String) -> Results<Item>? {
        var results: Results<Item>?
        if let items = itemsResults {
            results = items.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "title", ascending: true)
        }
        
        return results
    }
    
}





//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        var finalPredicate = NSPredicate()
//
//        var fetchResult = [Item]()
//
//        let sort = [NSSortDescriptor(key: "title", ascending: true)]
//
//        if predicate != nil {
//           finalPredicate = predicate!
//        } else if textFieldText != nil && itemCategory != nil {
//            finalPredicate = NSPredicate(format: "category.name MATCHES %@ AND title CONTAINS[cd] %@",
//                                         argumentArray: [itemCategory!.name!, textFieldText!])
//            request.sortDescriptors = sort
//        } else if itemCategory != nil {
//            finalPredicate = NSPredicate(format: "category.name MATCHES %@", itemCategory!.name!)
//        } else if textFieldText != nil {
//            finalPredicate = NSPredicate(format: "title CONTAINS[cd] %@", textFieldText!)
//            request.sortDescriptors = sort
//        }
//
//        request.predicate = finalPredicate
//
//        do {
//            fetchResult = try context.fetch(request)
//        } catch {
//            print("Error of fetching request \(error)")
//        }
//        delegate?.didLoadedItemsWith(fetchResult: fetchResult)

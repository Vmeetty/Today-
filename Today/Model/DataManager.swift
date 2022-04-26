//
//  DataManager.swift
//  Today
//
//  Created by user on 25.04.2022.
//

import Foundation
import CoreData
import UIKit

protocol DataManagerDelegate {
    func didLoadedItemsWith(fetchResult: [Item])
}


class DataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: DataManagerDelegate?
    
    static let shared = DataManager()
    
    
    func saveItems(complition: () -> Void) {
        do {
            try context.save()
            print("saved in CoreData")
        } catch {
            print("Error saving context: \(error)")
        }
        complition()
    }
    
    func saveItems() {
        do {
            try context.save()
            print("saved in CoreData")
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    
    func loadItemsWith(_ predicate: NSPredicate? = nil, textFieldText: String? = nil, itemCategory: Category? = nil) {

        let request: NSFetchRequest<Item> = Item.fetchRequest()
        var finalPredicate = NSPredicate()
        
        var fetchResult = [Item]()
        
        let sort = [NSSortDescriptor(key: "title", ascending: true)]
        
        if predicate != nil {
           finalPredicate = predicate!
        } else if textFieldText != nil && itemCategory != nil {
            finalPredicate = NSPredicate(format: "category.name MATCHES %@ AND title CONTAINS[cd] %@",
                                         argumentArray: [itemCategory!.name!, textFieldText!])
            request.sortDescriptors = sort
        } else if itemCategory != nil {
            finalPredicate = NSPredicate(format: "category.name MATCHES %@", itemCategory!.name!)
        } else if textFieldText != nil {
            finalPredicate = NSPredicate(format: "title CONTAINS[cd] %@", textFieldText!)
            request.sortDescriptors = sort
        }
    
        request.predicate = finalPredicate
        
        do {
            fetchResult = try context.fetch(request)
        } catch {
            print("Error of fetching request \(error)")
        }
        delegate?.didLoadedItemsWith(fetchResult: fetchResult)
    }
    
    func loadCategories(complion: ([Category]) -> Void) {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        var fetchResult = [Category]()
        do {
            fetchResult = try context.fetch(request)
        } catch {
            print("Fetching context failed: \(error)")
        }
        complion(fetchResult)
    }
    
}


//
//  NewData.swift
//  Today
//
//  Created by user on 26.04.2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var serious = false
    @objc dynamic var dateCreated: Date?
    var category = LinkingObjects(fromType: Category.self, property: "items")
}

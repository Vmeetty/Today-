//
//  Data.swift
//  Today
//
//  Created by user on 26.04.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}

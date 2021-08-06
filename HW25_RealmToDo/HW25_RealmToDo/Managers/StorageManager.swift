//
//  StorageManager.swift
//  HW25_RealmToDo
//
//  Created by Nata on 06.08.2021.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {

    static func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

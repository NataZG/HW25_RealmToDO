//
//  Task.swift
//  HW25_RealmToDo
//
//  Created by Nata on 06.08.2021.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}

//
//  TasksList.swift
//  HW25_RealmToDo
//
//  Created by Nata on 06.08.2021.
//

import Foundation
import RealmSwift

class TasksList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}

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
    
    static func saveTasksList(taskList: TasksList) {
        try! realm.write {
            realm.add(taskList)
        }
    }
    
    static func deleteList(_ tasksList: TasksList) {
            try! realm.write {
                let tasks = tasksList.tasks
                // последовательно удаляем tasks и tasksList
                realm.delete(tasks)
                realm.delete(tasksList)
            }
        }

        static func editList(_ tasksList: TasksList, newListName: String) {
            try! realm.write {
                tasksList.name = newListName
            }
        }

        static func makeAllDone(_ tasksList: TasksList) {
            try! realm.write {
                tasksList.tasks.setValue(true, forKey: "isComplete")
            }
        }

        // MARK: - Tasks Methods

        static func saveTask(_ tasksList: TasksList, task: Task) {
            try! realm.write {
                tasksList.tasks.append(task)
            }
        }

        static func editTask(_ task: Task, newNameTask: String, newNote: String) {
            try! realm.write {
                task.name = newNameTask
                task.note = newNote
            }
        }

        static func deleteTask(_ task: Task) {
            try! realm.write {
                realm.delete(task)
            }
        }

        static func makeDone(_ task: Task) {
            try! realm.write {
                task.isComplete.toggle()
            }
        }
    }

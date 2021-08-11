//
//  UITableViewCellExt.swift
//  HW25_RealmToDo
//
//  Created by Nata on 06.08.2021.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TasksList) {
        let currentTasks = tasksList.tasks.filter("isComplete = false")
        let completedTasks = tasksList.tasks.filter("isComplete = true")
        
        textLabel?.text = tasksList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .gray
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✅"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = .green
        } else {
            detailTextLabel?.text = "0"
        }
    }
}

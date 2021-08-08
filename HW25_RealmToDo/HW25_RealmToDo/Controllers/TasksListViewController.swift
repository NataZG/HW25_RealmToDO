//
//  TasksListViewController.swift
//  HW25_RealmToDo
//
//  Created by Nata on 06.08.2021.
//

import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {

    // Results - real time data
    var tasksLists: Results<TasksList>!
    var notificationToken: NotificationToken?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Clean Realm DB
        //StorageManager.deleteAll()

        // DB + sorting
        tasksLists = realm.objects(TasksList.self).sorted(byKeyPath: "name")

        // Realm notification
        notificationToken = tasksLists.observe { change in
            switch change {
            case .initial:
                print("initial element")
            case .update(_, let deletions, let insertions, let modifications):
                print("deletions: \(deletions)")
                print("insertions: \(insertions)")
                print("modifications: \(modifications)")
            case .error(let error):
                print("error: \(error)")
            }
        }
        navigationItem.leftBarButtonItem = editButtonItem
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        alertForAddAndUpdateList()
    }


    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let tasksList = tasksLists[indexPath.row]
        cell.textLabel?.text = tasksList.name
        cell.detailTextLabel?.text = String(tasksList.tasks.count)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = tasksLists[indexPath.row]
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            
        }
        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") {_,_,_ in
            
        }
        let doneContextItem = UIContextualAction(style: .destructive, title: "Done") {_,_,_ in
            
        }
        
        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = .green
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])
        
        return swipeActions
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func alertForAddAndUpdateList() {
        let title = "New List"
        let message = "Please insert List Name"

        let doneButtonName = "Save"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var alertTextField: UITextField!

        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { _ in

            guard let newList = alertTextField.text, !newList.isEmpty else { return }

            let taskList = TasksList()
            taskList.name = newList

            StorageManager.saveTasksList(taskList: taskList)
            self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }

        present(alert, animated: true)
    }

}

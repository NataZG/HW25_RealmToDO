//
//  TasksViewController.swift
//  HW25_RealmToDo
//
//  Created by Nata on 06.08.2021.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {

    var currentTasksList: TasksList!

    private var incomplete: Results<Task>!
    private var completedTasks: Results<Task>!

    private var isEditingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList.name
        filteringTasks()

        // navigationItem.rightBarButtonItem = editButtonItem
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        // isEditingMode.toggle()
        // tableView.setEditing(isEditingMode, animated: true)
    }


    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? incomplete.count : completedTasks.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "INCOMPLETE TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        var task: Task!
        task = indexPath.section == 0 ? incomplete[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let task = indexPath.section == 0 ? incomplete[indexPath.row] : completedTasks[indexPath.row]
        let deleteContextItem = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }


        let editContextItem = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            self.alertForAddAndUpdateList(task)
        }

        let doneContextItem = UIContextualAction(style: .destructive, title: "Done") { _, _, _ in
            StorageManager.makeDone(task)
            self.filteringTasks()

        }

        editContextItem.backgroundColor = .orange
        doneContextItem.backgroundColor = .green

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteContextItem, editContextItem, doneContextItem])

        return swipeActions
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try! realm.write {
            let tappedItem = incomplete[indexPath.row] as Task
            tappedItem.isComplete = !tappedItem.isComplete }
        tableView.reloadData()
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

    private func filteringTasks() {
        incomplete = currentTasksList.tasks.filter("isComplete = false")
        completedTasks = currentTasksList.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
}

extension TasksViewController {
    private func alertForAddAndUpdateList(_ taskName: Task? = nil) {
        var title = "New Task"
        let message = "Please insert task value"
        var doneButton = "Save"

        if taskName != nil {
            title = "Edit Task"
            doneButton = "Update"
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!

        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in

            guard let newTask = taskTextField.text, !newTask.isEmpty else { return }

            if let taskName = taskName {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newNameTask: newTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newNameTask: newTask, newNote: "")
                }
                self.filteringTasks()
            } else {
                let task = Task()
                task.name = newTask
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = note
                }
                StorageManager.saveTask(self.currentTasksList, task: task)
                self.filteringTasks()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "New Task"

            if let taskName = taskName {
                taskTextField.text = taskName.name
            }
        }

        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"

            if let taskName = taskName {
                noteTextField.text = taskName.note
            }
        }

        present(alert, animated: true)
    }
}

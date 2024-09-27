//
//  TaskDetailsViewController.swift
//  DeadLine
//
//  Created by Андрей Кравцов on 29.05.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class TaskDetailsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tfDescription: UITextField!
    @IBOutlet var tfPriority: UISlider!
    @IBOutlet var sldrPriority: UISlider!
    @IBOutlet var btnAdd: UIButton!
    let db = FirebaseDb()

    var task = ""
    var index = IndexPath()
    
    private lazy var databasePath: DatabaseReference? = {
      guard let uid = Auth.auth().currentUser?.uid else {
        return nil
      }
      let ref = Database.database()
        .reference()
        .child("users/\(uid)/tasks")
      return ref
    }()

    @IBAction func addTask(_ sender: Any){
        // Create a new alert
        let dialogMessage = UIAlertController(title: "Ошибка", message: "Авторизируйтесь, чтобы добавить задачу", preferredStyle: .alert)
        let dialogMessage1 = UIAlertController(title: "Успешно", message: "Задача успешно добавлена", preferredStyle: .alert)
        if (Auth.auth().currentUser == nil){
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             })
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
        }else{
            let updatedTask = Task(Title: self.tfTitle.text ?? "-", Description: self.tfDescription.text ?? "-", Priority: self.tfPriority.value , Done: false)
            self.db.updateTask(task: updatedTask, oldTitle: self.task)
            self.navigationController?.popViewController(animated: true)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             })
            //Add OK button to a dialog message
            dialogMessage1.addAction(ok)
            // Present alert to user
            self.present(dialogMessage1, animated: true, completion: nil)
        }
    }

    override func viewDidLoad(){
        let compl: (_ flag: Bool, _ task: Task) -> Void = { ready, task in
            if ready{
                super.viewDidLoad()
                self.load_task(gotTask: task)
            }
        }
        _ = self.db.getTask(taskTitle: self.task, using: compl)
        tfTitle.delegate = self
        
    }
    
    func load_task(gotTask: Task){
        self.tfTitle.text = gotTask.Title
        self.tfDescription.text = gotTask.Description
        self.tfPriority.value = gotTask.Priority
    }


}

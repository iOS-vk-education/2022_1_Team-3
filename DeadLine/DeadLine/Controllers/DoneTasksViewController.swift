////
////  TasksViewController.swift
////  DeadLine
////
////  Created by Roman Nizovtsev on 18.04.2022.
////

import UIKit
import FirebaseAuth
import FirebaseDatabase
class DoneTasksViewController: UITableViewController {
    @IBOutlet weak var addBtn: UIButton!
    var Tasks: [Task] = []
    let db = FirebaseDb()
    
    @IBAction func onClickDeleteButton2(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        let reference = self.db.databasePath?.ref.child(Tasks[indexpath.row].Title)
        reference?.removeValue { error, _ in
                     print(error?.localizedDescription ?? "error")
                 }
        Tasks.remove(at: indexpath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        tableView.endUpdates()
        
    }

    @IBAction func radioSelected1(_ sender: UIButton) {
        sender.isSelected = true
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        let reference = self.db.databasePath?.ref.child(Tasks[indexpath.row].Title)
        if(Tasks[indexpath.row].Done == true)
        {
        Tasks[indexpath.row].Done = false
            do {
                let data = try self.db.encoder.encode(Tasks[indexpath.row])
              let json = try JSONSerialization.jsonObject(with: data)
                reference?
                .setValue(json)
            } catch {
              print("an error occurred", error)
            }
        Tasks.remove(at: indexpath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        tableView.endUpdates()
        }
    }
   
    @IBAction func celSelected(_ sender: UIButton){
        print("click")
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        let param = Tasks[indexpath.row].Title
        let vc = storyboard?.instantiateViewController(withIdentifier: "taskDetails_vc") as! TaskDetailsViewController
        vc.task = param
        navigationController?.pushViewController(vc, animated: true)
    }

    private let decoder = JSONDecoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let compl: (_ flag: Bool, _ tasks: [Task]) -> Void = { ready, tasks in
            if ready{
                self.Tasks.removeAll()
                self.Tasks = tasks
                let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
                self.tableView.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.allowsSelection = false
                self.tableView.reloadData()
                print("compl1")
            }
        }
        print("appear")
        let compl2: (Bool) -> Void = { ready in
            if ready {
                self.db.loadAllTasks(done: true, using: compl)
                print("compl2")
            }
        }
       
        if (self.db.signIn(using: compl2) == 0)
        {
            self.Tasks.removeAll()
            self.tableView.reloadData()
        }
       
    }
    
    // MARK: - Table view data source
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Tasks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! DemoTableViewCell
        if(Tasks.count>0)
        {
        cell.myLablel?.text =  Tasks[indexPath.row].Title
        }
        return cell
    }
}

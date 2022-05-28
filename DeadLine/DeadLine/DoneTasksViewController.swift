//
//  DoneTasksViewController.swift
//  DeadLine
//
//  Created by Андрей Кравцов on 28.05.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class DoneTasksViewController: UITableViewController {
    var Tasks: [Task] = []
    var tasks = ["first","second"]
    private lazy var databasePath: DatabaseReference? = {
      // 1
      guard let uid = Auth.auth().currentUser?.uid else {
        return nil
      }

      // 2
      let ref = Database.database()
        .reference()
        .child("users/\(uid)/tasks")
      return ref
    }()

    // 3
    private let decoder = JSONDecoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        loadFirebase()
    }
    
        
        func updateTasks(){
            print("Updata table")
            tasks.removeAll()
            guard let count = UserDefaults().value(forKey: "count") as? Int else {
                return
            }
            for x in 0..<count{
                if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String{
                    tasks.append(task)
                }
            }
            //tasks.append("!!!!")
            print(tasks)
            tableView.reloadData()
    
    
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
        print("ALL TASSKS", tasks.count, tasks)
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! DemoTableViewCell

        
        cell.myLablel?.text =  Tasks[indexPath.row].Title
        return cell
    }

    func loadFirebase()
    {
        
        guard let databasePath = databasePath else {
          return
        }

        // 2
        databasePath
          .observe(.childAdded) { [weak self] snapshot in

            // 3
            guard
              let self = self,
              var json = snapshot.value as? [String: Any]
            else {
              return
            }

            // 4
            json["id"] = snapshot.key

            do {

              // 5
              let taskData = try JSONSerialization.data(withJSONObject: json)
              // 6
              let task = try self.decoder.decode(Task.self, from: taskData)
              // 7
                if (task.Done == true){
                    self.Tasks.append(task)
                }
            } catch {
              print("an error occurred", error)
            }
              print("Done Tasks")
              print(self.Tasks)
              self.tableView.reloadData()
          }
    }
}
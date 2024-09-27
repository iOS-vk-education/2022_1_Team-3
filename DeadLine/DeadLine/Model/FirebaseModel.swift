//
//  FirebaseModel.swift
//  DeadLine
//
//  Created by Андрей Кравцов on 30.05.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseDb{
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    public lazy var databasePath: DatabaseReference? = {
      guard let uid = Auth.auth().currentUser?.uid else {
        return nil
      }
      let ref = Database.database()
        .reference()
        .child("users/\(uid)/tasks")
      return ref
    }()
    
    func setTask(task: Task){
        do {
          let data = try encoder.encode(task)
          let json = try JSONSerialization.jsonObject(with: data)
            self.databasePath?.child(task.Title)
            .setValue(json)
           
        } catch {
          print("an error occurred", error)
        }
    }
    func signIn(using compl2: @escaping(Bool) -> Void) -> Int
    
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            print ("Mist")
            return 0
        }
             self.databasePath = Database.database()
                 .reference()
                 .child("users/\(uid)/tasks")
        print("sign")
        compl2(true)
        return 1
    }
    func getTask(taskTitle: String, using compl: @escaping (_ flag: Bool,_ task: Task) -> Void)  -> Task{
        var task = Task(Title:  "-",Description: "-",Priority: 0.5, Done: false)
        self.databasePath?.child(taskTitle).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            task.Title = value?["Title"] as? String ?? ""
            task.Description = value?["Description"] as? String ?? ""
            task.Priority = value?["Priority"] as? Float ?? 0.5
            compl(true, task)
            }) { error in
              print(error.localizedDescription)
            }
        return task
    }
    
    func updateTask(task: Task, oldTitle: String){
        do {
          let data = try encoder.encode(task)
          let json = try JSONSerialization.jsonObject(with: data)
            if (task.Title ==  oldTitle){
                self.databasePath?.child(oldTitle)
                    .updateChildValues(json as! [AnyHashable : Any])
            }else{
                self.databasePath?.child(oldTitle).removeValue { error, _ in
                    print(error?.localizedDescription ?? "error")
                         }
                self.databasePath?.child(task.Title)
                .setValue(json)
            }
        } catch {
          print("an error occurred", error)
        }
    }
    
    func loadAllTasks(done : Bool, using compl: @escaping (_ flag: Bool,_ tasks: [Task]) -> Void)
    {
        var Tasks: [Task] = []
        self.databasePath?
          .observe(.childAdded) { [weak self] snapshot in
            guard
              let self = self,
              let json = snapshot.value as? [String: Any]
            else {
              return
            }
            do {
              let taskData = try JSONSerialization.data(withJSONObject: json)
              let task = try self.decoder.decode(Task.self, from: taskData)
                if(task.Done == done){
                    Tasks.append(task)
                }
            } catch {
              print("an error occurred", error)
            }
              compl(true, Tasks)
          }
    }
}

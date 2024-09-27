//
//  OtherViewController.swift
//  DeadLine
//
//  Created by Roman Nizovtsev on 18.04.2022.
//

import UIKit
import Firebase

class OtherViewController: UIViewController {
    let defaults = UserDefaults.standard
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnIn: UIButton!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnOut: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    private lazy var databasePath: DatabaseReference? = {
      guard let uid = Auth.auth().currentUser?.uid else {
        return nil
      }
      let ref = Database.database()
        .reference()
        .child("users/\(uid)/tasks")
      return ref
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if (Auth.auth().currentUser == nil)
        {
            lblEmail.text = "Авторизируйтесь для начала работы с приложением"
            btnDel.isHidden = true
            btnAbout.isHidden = true
            btnOut.isHidden = true
            btnIn.isHidden = false
            btnRegister.isHidden = false
        }
        else
        {
            btnDel.isHidden = false
            btnAbout.isHidden = false
            btnOut.isHidden = false
            btnIn.isHidden = true
            btnRegister.isHidden = true
            let value = defaults.string(forKey: "user")
            lblEmail.text = value
        }
    }
    
    @IBAction func btnOutClicked(_ sender: Any) {
        try! Auth.auth().signOut()
        lblEmail.text = "Авторизируйтесь для начала работы с приложением"
        btnOut.isHidden = true
        btnIn.isHidden = false
        btnRegister.isHidden = false
        btnDel.isHidden = true
        btnAbout.isHidden = true
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Удалено", message: "Задачи успешно удалены", preferredStyle: .alert)
        databasePath?.ref.removeValue { error, _ in
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             })
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnAboutClicked(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "О приложении", message: "Приложение было разработано командой DeadLine.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in})
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
}

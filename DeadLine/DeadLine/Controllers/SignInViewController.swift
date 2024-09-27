//
//  SignInViewController.swift
//  DeadLine
//
//  Created by Roman Nizovtsev on 19.04.2022.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {
    @IBOutlet weak var login_text: UITextField!
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var sign_in_btn: UIButton!
    @IBOutlet weak var pass1_text: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignInClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: login_text.text!, password: pass1_text.text!) { (user, error) in
           if error == nil{
               let email = self.login_text.text
               self.userDefaults.set(email, forKey: "user")
               self.viewWillAppear(true)
               self.navigationController?.popViewController(animated: true)
               
            }else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

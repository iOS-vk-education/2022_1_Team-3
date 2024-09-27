//
//  SignUpViewController.swift
//  DeadLine
//
//  Created by Roman Nizovtsev on 19.04.2022.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    @IBOutlet weak var login_text: UITextField!
    @IBOutlet weak var sign_up_btn: UIButton!
    @IBOutlet weak var pass2_text: UITextField!
    @IBOutlet weak var pass1_text: UITextField!
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignUpClicked(_ sender: Any) {
        if pass1_text.text != pass2_text.text {
        let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        }else{
            Auth.auth().createUser(withEmail: login_text.text!, password: pass1_text.text!){ (user, error) in
                if error == nil {
                    let email = self.login_text.text
                    //let user = User(login: email!)
                    self.userDefaults.set(email, forKey: "user")
                    // Write User to User's Defaults
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
}

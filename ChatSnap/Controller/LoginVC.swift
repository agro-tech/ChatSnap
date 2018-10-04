//
//  LoginVC.swift
//  ChatSnap
//
//  Created by Alan Ramos on 5/6/18.
//  Copyright © 2018 Alan Ramos. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailField.text, let pass = passwordField.text, (email.count > 0 && pass.count > 0) {
            
            AuthService.instance.login(email: email, password: pass) { (errMsg, data) in
                guard errMsg == nil else {
                    let alert = UIAlertController (title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
            //Call the login service

        } else {
            let alert = UIAlertController(title: "Username and Password Required", message: "You must ener both a username amd a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

//
//  LogInViewController.swift
//  BikeCoummuter
//
//  Created by Erik Hede on 2018-03-21.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func loginTapped(_ sender: UIButton) {
        // logga in anv'ndare
    }
    
    @IBAction func signinTapped(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                // Användare skapad
                print("Registrering lyckad")
                self.performSegue(withIdentifier: "goToSetGoal", sender: self)
            }
        }
    }
    
}

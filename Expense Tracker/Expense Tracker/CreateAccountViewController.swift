//
//  CreateAccountViewController.swift
//  Expense Tracker
//
//  Created by Danyal Nemati on 11/22/23.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController
{
    
    @IBOutlet weak var emailTextField    : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet var createSubmit           : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult,
            error in if let e = error {
                print("Error creating new account: \(e.localizedDescription)")
                
                let alert = UIAlertController(title: "Error creating new account.",
                    message: "Account already exist or email/password does not meet requirements.",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                self.performSegue(withIdentifier: "goToNext", sender: self)
                print("Successfully created new account!")
                
                let alert = UIAlertController(title: "Successfully created new account.",
                    message: "Welcome to Expense Tracker app.",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        print("Background tapped!")
    }
    
}

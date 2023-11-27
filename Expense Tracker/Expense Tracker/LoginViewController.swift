//
//  LoginViewController.swift
//  Expense Tracker
//
//  Created by Danyal Nemati on 11/22/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var emailTextField    : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet var loginSubmit            : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult,
            error in if let e = error {
                print("User login error: \(e.localizedDescription)")
                
                let alert = UIAlertController(title: "Login error.",
                    message: "Please re-enter valid login credentials.",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                self.performSegue(withIdentifier: "goToNext", sender: self)
                print("Successfully logged in!")
                
                let alert = UIAlertController(title: "Login Successful.",
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

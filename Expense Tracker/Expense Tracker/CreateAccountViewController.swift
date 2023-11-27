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
    
    //func setBackGround() {
    //    let colorTop = UIColor(red: 132.0/255.0, green: 104.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
    //    let colorBottom = UIColor(red: 39.0/255.0, green: 16.0/255.0, blue: 107.0/255.0, alpha: 1.0).cgColor
    //
    //    let gradientLayer = CAGradientLayer()
    //    gradientLayer.colors = [colorTop, colorBottom]
    //    gradientLayer.locations = [0.0, 1.0]
    //    gradientLayer.frame = self.view.bounds
    //}
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

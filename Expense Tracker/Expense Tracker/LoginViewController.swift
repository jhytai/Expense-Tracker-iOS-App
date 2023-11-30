//
//  LoginViewController.swift
//  Expense Tracker
//
//  Created by Danyal Nemati on 11/22/23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField    : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet var loginSubmit            : UIButton!

    public var accEmail : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                print("User login error:")

                let alert = UIAlertController(title: NSLocalizedString("Login error.", comment: "Login error"),
                                              message: NSLocalizedString("Please re-enter valid login credentials.", comment: "Please re-enter valid login credentials."),
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            } else {
                self.performSegue(withIdentifier: "goToNext", sender: self)
                print("Successfully logged in as \(self.accEmail)")

                let alert = UIAlertController(title: NSLocalizedString("Login Successful.", comment: "Login Successful"),
                                              message: NSLocalizedString("Welcome to Expense Tracker app.", comment: "Welcome to Expense Tracker app."),
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                Global.accEmail = self.emailTextField.text ?? ""
            }
        }
    }

    @IBAction func emailTextFieldEdited(_ textField: UITextField) {
        let text = textField.text ?? ""
        accEmail = String(text)
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        print("Background tapped!")
    }

}

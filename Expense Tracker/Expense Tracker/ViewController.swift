//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Danyal Nemati on 11/16/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var appTitleLabel   : UILabel!
    @IBOutlet var appLogoImage    : UIImageView!
    @IBOutlet var loginButton     : UIButton!
    @IBOutlet var createAccButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped (_ sender: UIButton) {
        print("Login button tapped!")
    }
    
    @IBAction func createAccButtonTapped (_ sender: UIButton) {
        print("Create account button tapped!")
    }
    
}

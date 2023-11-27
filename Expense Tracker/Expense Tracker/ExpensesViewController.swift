//
//  Expenses.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/26/23.
//

import UIKit

class ExpensesViewController: UIViewController {
    
    private var expPageTitle     : UILabel!
    private var expTitleLabel    : UILabel!
    private var expTitle         : UITextField!
    private var expCategoryLabel : UILabel!
    private var expCategory      : UITextField!
    private var expAmountLabel   : UILabel!
    private var expAmount        : UITextField!
    private var expDateLabel     : UILabel!
    private var expDate          : UITextField!
    private var submitButton     : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        
        // Initialize Expenses Page Title Label
        self.expPageTitle = UILabel()
        self.expPageTitle.text = "Add Expense"
        self.expPageTitle.font = UIFont.systemFont(ofSize: 32)
        self.expPageTitle.numberOfLines = 0
        self.expPageTitle.lineBreakMode = .byWordWrapping
        self.expPageTitle.textAlignment = .center
        self.expPageTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(expPageTitle)
        
        // Set up contraints
        NSLayoutConstraint.activate([
            // Constrain welcomeLabel
            self.expPageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.expPageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.expPageTitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.expPageTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            ])
    }
    
    
}

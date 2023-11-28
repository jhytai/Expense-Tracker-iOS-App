//
//  CategoryViewController.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/27/23.
//

import UIKit

class CategoryViewController: UIViewController {

    private var catPageTitle     : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func loadView() {
        super.loadView()
        
        // Initialize Expenses Page Title Label
        self.catPageTitle = UILabel()
        self.catPageTitle.text = "Expenses by Category"
        self.catPageTitle.font = UIFont.systemFont(ofSize: 28)
        self.catPageTitle.numberOfLines = 0
        self.catPageTitle.lineBreakMode = .byWordWrapping
        self.catPageTitle.textAlignment = .center
        self.catPageTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(catPageTitle)
        
        // Set up contraints
        NSLayoutConstraint.activate([
            // Constrain welcomeLabel
            self.catPageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.catPageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.catPageTitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.catPageTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            ])
    }

}

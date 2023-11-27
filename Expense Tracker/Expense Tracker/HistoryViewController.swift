//
//  History.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/26/23.
//

import UIKit

class HistoryViewController: UIViewController {

    private var histPageTitle     : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func loadView() {
        super.loadView()
        
        // Initialize Expenses Page Title Label
        self.histPageTitle = UILabel()
        self.histPageTitle.text = "Expenses History"
        self.histPageTitle.font = UIFont.systemFont(ofSize: 28)
        self.histPageTitle.numberOfLines = 0
        self.histPageTitle.lineBreakMode = .byWordWrapping
        self.histPageTitle.textAlignment = .center
        self.histPageTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(histPageTitle)
        
        // Set up contraints
        NSLayoutConstraint.activate([
            // Constrain welcomeLabel
            self.histPageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.histPageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.histPageTitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.histPageTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            ])
    }

}

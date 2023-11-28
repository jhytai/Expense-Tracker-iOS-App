//
//  LaunchViewController.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/27/23.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setGradientBackground()
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        // Add the gradient layer to the view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

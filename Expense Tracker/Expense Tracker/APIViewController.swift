//
//  APIViewController.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/29/23.
//

import UIKit

enum Endpoint: String {
    case get = ""
}

class APIViewController: UIViewController {
    
    private static let baseURLString = ""
    
//    static var getDogsURL: URL{
//        return self.getDogsURL(
//            endpoint: Endpoint.get,
//            parameters: nil
//        )
//    }
    
    private static func dogURL(
        endpoint: Endpoint,
        parameters: [String:String]?
    )->URL
    {
        let endpoint = self.baseURLString + endpoint.rawValue
        
        var components = URLComponents(string: endpoint)!
        
        var queryItems = [URLQueryItem]()
        
        let baseQueryParameters = [
            "dummy": "value"
        ]
        for(key,value) in baseQueryParameters{
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParameters = parameters{
            for(key, value) in additionalParameters{
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func loadView() {
        super.loadView()
    }
    
    
    
}

//
//  APIViewController.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/29/23.
//

import UIKit

class APIViewController: UIViewController {
    
    private static let baseURLString = "https://api.thedogapi.com/"  // base URL
    private let apiKey = "live_y3W616JKCSLO9L7xGChlWCJmggDRu81SH4P4NcYSzhy45UU3qecSfN91agHaAuIf"
    enum Endpoint: String {
        case getDogs = "dogs"
    }
    
    private func dogURL(
        endpoint: Endpoint,
        parameters: [String: String]?
    ) -> URL {
        let urlString = APIViewController.baseURLString + endpoint.rawValue
        var components = URLComponents(string: urlString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseQueryParameters = [
            "dummy": "value",
            "apiKey": apiKey
        ]
        
        for (key, value) in baseQueryParameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParameters = parameters {
            for (key, value) in additionalParameters {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let dogsURL = dogURL(endpoint: .getDogs, parameters: nil)
        print("Dogs URL: \(dogsURL)")
        
        // Uncomment to see API
         fetchDogs()
    }
    
    private func fetchDogs() {
        let dogsURL = dogURL(endpoint: .getDogs, parameters: nil)
        
        let task = URLSession.shared.dataTask(with: dogsURL) { data, response, error in
            if let error = error {
                print("Error fetching dogs: \(error.localizedDescription)")
                return
            }
            if let data = data {
                
                print("Received data: \(data)")
            }
        }
        
        task.resume()
    }
}


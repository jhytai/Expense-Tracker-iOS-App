//
//  ExpenseData.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/29/23.
//

import Foundation
import CoreData

struct ExpenseData {
    var title: String
    var category: String
    var amount: Double
    var date: Date
    var accEmail: String
    
    init(title: String, category: String, amount: Double, date: Date, accEmail: String) {
        self.title = title
        self.category = category
        self.amount = amount
        self.date = date
        self.accEmail = accEmail
    }
}

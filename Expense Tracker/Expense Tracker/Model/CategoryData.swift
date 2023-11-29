//
//  CategoryData.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/29/23.
//

import Foundation
import CoreData

struct CategoryData {
    var category: String
    var expenses: [ExpenseEntity]
    var subtotal: Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }

    init(category: String, expenses: [ExpenseEntity]) {
        self.category = category
        self.expenses = expenses.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
    }
}

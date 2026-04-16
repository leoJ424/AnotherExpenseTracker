//
//  Expense.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/15/26.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var amount: Double
    var date: Date
    var category: Category
    var note: String
    
    init(amount: Double, date: Date = .now, category: Category, note: String = ""){
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
    }
    
}

extension Expense {
    static let samples: [Expense] = [
        Expense(amount: 4.75, date: .now.addingTimeInterval(-86400 * 0), category: .food, note: "Morning Coffee"),
        Expense(amount: 32.50, date: .now.addingTimeInterval(-86400 * 1), category: .food, note: "Dinner with friends"),
        Expense(amount: 12.00, date: .now.addingTimeInterval(-86400 * 2), category: .transport, note: "Uber to airport"),
        Expense(amount: 89.99, date: .now.addingTimeInterval(-86400 * 3), category: .shopping, note: "New headphones"),
        Expense(amount: 65.00, date: .now.addingTimeInterval(-86400 * 5), category: .bills, note: "Internet"),
        Expense(amount: 15.50, date: .now.addingTimeInterval(-86400 * 6), category: .entertainment, note: "Movie ticket"),
        Expense(amount: 25.00, date: .now.addingTimeInterval(-86400 * 8), category: .health, note: "Pharmacy"),
        Expense(amount: 8.25, date: .now.addingTimeInterval(-86400 * 10), category: .food, note: "Lunch")
    ]
}


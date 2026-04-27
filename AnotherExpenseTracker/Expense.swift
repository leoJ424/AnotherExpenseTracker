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
    var account: Account
    var sourceSchedule: RecurringExpense?
    
    init(amount: Double, date: Date = .now, category: Category, note: String = "", account: Account){
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
        self.account = account
    }
    
}

extension Expense {
    static let samples: [Expense] = {
        
        let cash = Account.samples[0] // Cash (default)
        let checking = Account.samples[1] // Chase Checking
        let amex = Account.samples[2] // Amex Gold
        
        return [
            Expense(amount: 4.75, date: .now.addingTimeInterval(-86400 * 0), category: .food, note: "Morning Coffee", account: cash),
            Expense(amount: 32.50, date: .now.addingTimeInterval(-86400 * 1), category: .food, note: "Dinner with friends", account: amex),
            Expense(amount: 12.00, date: .now.addingTimeInterval(-86400 * 2), category: .transport, note: "Uber to airport", account: amex),
            Expense(amount: 89.99, date: .now.addingTimeInterval(-86400 * 3), category: .shopping, note: "New headphones", account: amex),
            Expense(amount: 65.00, date: .now.addingTimeInterval(-86400 * 5), category: .bills, note: "Internet", account: checking),
            Expense(amount: 15.50, date: .now.addingTimeInterval(-86400 * 6), category: .entertainment, note: "Movie ticket", account: amex),
            Expense(amount: 25.00, date: .now.addingTimeInterval(-86400 * 8), category: .health, note: "Pharmacy", account: cash),
            Expense(amount: 8.25, date: .now.addingTimeInterval(-86400 * 10), category: .food, note: "Lunch", account: cash)
        ]
    }()
}


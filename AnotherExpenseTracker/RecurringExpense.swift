//
//  RecurringExpense.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/27/26.
//

import Foundation
import SwiftData

@Model
final class RecurringExpense {
    var amount: Double
    var category: Category
    var account: Account
    var note: String
    var frequency: Frequency
    var startDate: Date
    var endDate: Date?
    var lastGeneratedDate: Date?
    
    @Relationship(deleteRule: .nullify, inverse: \Expense.sourceSchedule)
    var generatedExpenses: [Expense] = []
    
    init(
        amount: Double,
        category: Category,
        account: Account,
        note: String = "",
        frequency: Frequency,
        startDate: Date,
        endDate: Date? = nil,
        lastGeneratedDate: Date? = nil
    ) {
        self.amount = amount
        self.category = category
        self.account = account
        self.note = note
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.lastGeneratedDate = lastGeneratedDate
    }
    
}

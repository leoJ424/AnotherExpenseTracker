//
//  Budget.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/23/26.
//

import Foundation
import SwiftData

@Model
final class Budget {
    var category: Category
    var amount: Double
    
    init(category: Category, amount: Double) {
        self.category = category
        self.amount = amount
    }
}

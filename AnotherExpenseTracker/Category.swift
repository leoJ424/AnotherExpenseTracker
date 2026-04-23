//
//  Category.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/15/26.
//

import Foundation

enum Category: String, CaseIterable, Codable, Identifiable {
    case food = "Food"
    case transport = "Transport"
    case shopping = "Shopping"
    case bills = "Bills"
    case entertainment = "Entertainment"
    case health = "Health"
    case other = "Other"
    
    var id: String { rawValue }
}

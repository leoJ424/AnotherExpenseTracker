//
//  AccountType.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/21/26.
//

import Foundation

enum AccountType: String, CaseIterable, Codable {
    case checking = "Checking"
    case savings = "Savings"
    case creditCard = "Credit Card"
    case cash = "Cash"
}

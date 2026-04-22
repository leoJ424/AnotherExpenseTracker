//
//  Account.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/21/26.
//

import Foundation
import SwiftData

@Model
final class Account {
    var name: String
    var type: AccountType
    var isDefault: Bool
    
    init(name: String, type: AccountType, isDefault: Bool = false){
        self.name = name
        self.type = type
        self.isDefault = isDefault
    }
    
}

extension Account {
    static let samples: [Account] = [
        Account(name: "Cash", type:.cash, isDefault: true),
        Account(name: "Chase Checking", type: .checking),
        Account(name: "Amex Gold", type: .creditCard)
    ]
}

//
//  Frequency.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/27/26.
//

import Foundation

enum Frequency: String, Codable, CaseIterable, Identifiable {
    case weekly = "Weekly"
    case biweekly = "Biweekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var id: String { rawValue }
}

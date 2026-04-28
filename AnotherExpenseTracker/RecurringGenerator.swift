//
//  RecurringGenerator.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/28/26.
//

import Foundation
import SwiftData

enum RecurringGenerator {
    
    // Walks every recurring schedule and creates any 'Expense' records due on or before today.
    // Safe to call repeatedly - already-generated occurrences are skipped via 'lastGeneratedDate'
    static func runAll(in context: ModelContext) {
        let descriptor = FetchDescriptor<RecurringExpense>()
        guard let schedules = try? context.fetch(descriptor) else { return }
        
        for schedule in schedules {
            run(for: schedule, in: context)
        }
        
        try? context.save()
    }
    
    // Generates due occurrences for a single schedule
    private static func run(for schedule: RecurringExpense, in context: ModelContext) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        
        // Determine the first date we're owed.
        var nextDate: Date
        if let last = schedule.lastGeneratedDate {
            guard let advance = advance(from: last, frequency: schedule.frequency) else { return }
            nextDate = calendar.startOfDay(for: advance)
        } else {
            nextDate = calendar.startOfDay(for: schedule.startDate)
        }
        
        var lastGenerated: Date? = schedule.lastGeneratedDate
        
        while nextDate <= today {
            if let endDate = schedule.endDate, nextDate > endDate {
                break
            }
            
            let expense = Expense(
                amount: schedule.amount,
                date: nextDate,
                category: schedule.category,
                note: schedule.note,
                account: schedule.account
            )
            expense.sourceSchedule = schedule
            context.insert(expense)
            
            lastGenerated = nextDate
            
            guard let advance = advance(from: nextDate, frequency: schedule.frequency) else { break }
            nextDate = advance
        }
        
        if lastGenerated != schedule.lastGeneratedDate {
            schedule.lastGeneratedDate = lastGenerated
        }
    }
    
    private static func advance(from date: Date, frequency: Frequency) -> Date? {
        let calendar = Calendar.current
        switch frequency {
        case .weekly: return calendar.date(byAdding: .day, value: 7, to: date)
        case .biweekly: return calendar.date(byAdding: .day, value: 14, to: date)
        case .monthly: return calendar.date(byAdding: .month, value: 1, to: date)
        case .yearly: return calendar.date(byAdding: .year, value: 1, to: date)
        }
    }
}

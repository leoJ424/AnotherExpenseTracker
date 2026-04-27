//
//  RecurringListView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/27/26.
//

import SwiftUI
import SwiftData

struct RecurringListView: View {
    @Query(sort: \RecurringExpense.startDate) private var schedules: [RecurringExpense]
    
    var body: some View {
        Group {
            if schedules.isEmpty {
                EmptySchedulesView()
            }
            else {
                List {
                    ForEach(schedules) { schedule in
                        RecurringRow(schedule: schedule)
                    }
                }
            }
        }
    }
}

struct RecurringRow: View {
    let schedule: RecurringExpense
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName(for: schedule.category))
                .font(.title3)
                .frame(width: 28)
                .foregroundStyle(.tint)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(schedule.category.rawValue)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(schedule.amount, format: .currency(code: "USD"))
                        .font(.headline)
                        .monospacedDigit()
                }
                
                HStack {
                    Text(schedule.frequency.rawValue)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Text("·")
                        .foregroundStyle(.secondary)
                    
                    Text(schedule.account.name)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    if let next = nextDueDate {
                        Text("Next: \(next, format: .dateTime.month(.abbreviated).day().year())")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                    } else {
                        Text("Ended")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if !schedule.note.isEmpty {
                    Text(schedule.note)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private var nextDueDate: Date? {
        if let endDate = schedule.endDate, endDate < .now {
            return nil
        }
        
        guard let lastGenerated = schedule.lastGeneratedDate else {
            return schedule.startDate
        }
        
        let calendar = Calendar.current
        let next: Date?
        switch schedule.frequency {
        case .weekly:
            next = calendar.date(byAdding: .day, value: 7, to: lastGenerated)
        case .biweekly:
            next = calendar.date(byAdding: .day, value: 14, to: lastGenerated)
        case .monthly:
            next = calendar.date(byAdding: .month, value: 1, to: lastGenerated)
        case .yearly:
            next = calendar.date(byAdding: .year, value: 1, to: lastGenerated)
        }
        
        if let endDate = schedule.endDate, let nextDate = next, nextDate > endDate {
            return nil
        }
        
        return next
    }
    
    private func iconName(for category: Category) -> String {
        switch category {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "bag.fill"
        case .bills: return "doc.text.fill"
        case .entertainment: return "play.tv.fill"
        case .health: return "cross.case.fill"
        case .other: return "tag.fill"
        }
    }
}

struct EmptySchedulesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No recurring expenses yet")
                .font(.title2)
                .foregroundStyle(.secondary)
            Text("Add one to track expenses that repeat.")
                .font(.callout)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RecurringListView()
        .modelContainer(for: [Expense.self, Account.self, Budget.self, RecurringExpense.self], inMemory: true)
}

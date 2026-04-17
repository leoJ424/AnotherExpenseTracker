//
//  ExpenseListView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/16/26.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    
    private var total: Double {
        expenses.reduce(0) { runningTotal, expense in
                runningTotal + expense.amount
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(expenses) { expense in
                    //Text("\(expense.category.rawValue): $\(expense.amount)")
                    ExpenseRow(expense: expense)
                }
            }
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.headline)
                
                Spacer()
                
                Text(total, format: .currency(code: "USD"))
                    .font(.headline)
                    .monospacedDigit()
            }
            .padding()
        }
    }
}

struct ExpenseRow: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: iconName(for: expense.category))
                .font(.title3)
                .frame(width: 28)
                .foregroundStyle(.tint)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(expense.category.rawValue)
                    .font(.headline)
                if(!expense.note.isEmpty) {
                    Text(expense.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(expense.amount, format: .currency(code: "USD"))
                    .font(.headline)
                    .monospacedDigit()
                Text(expense.date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
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

#Preview {
    ExpenseListView()
        .modelContainer(for: Expense.self, inMemory: true)
}

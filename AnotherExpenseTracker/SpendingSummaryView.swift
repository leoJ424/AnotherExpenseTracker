//
//  SpendingSummaryView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/17/26.
//

import SwiftUI
import SwiftData
import Charts

struct SpendingSummaryView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    
    private var spendingByCategory: [(category: Category, total: Double)] {
        var totals: [Category: Double] = [:]
        for expense in expenses {
            totals[expense.category, default: 0] += expense.amount
        }
        return totals
            .map{ (category: $0.key, total: $0.value) }
            .sorted{ $0.total > $1.total }
    }
    
    private var grandTotal: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    private var dailySpending: [(date: Date, total: Double)] {
        let calendar = Calendar.current
        var totals: [Date: Double] = [:]
        for expense in expenses {
            let day = calendar.startOfDay(for: expense.date)
            totals[day, default: 0] += expense.amount
        }
        return totals
            .map{ (date: $0.key, total: $0.value) }
            .sorted{ $0.date < $1.date }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Spending Summary")
                    .font(.title)
                    .fontWeight(.bold)
                
                GroupBox("Spending by Category") {
                    if spendingByCategory.isEmpty {
                        Text("No expenses to display")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        HStack(alignment: .top, spacing: 32) {
                            Chart(spendingByCategory, id: \.category) { item in
                                SectorMark(
                                    angle: .value("Amount", item.total),
                                    innerRadius: .ratio(0.6),
                                    angularInset: 1.5
                                )
                                .foregroundStyle(by: .value("Category", item.category.rawValue))
                                .cornerRadius(4)
                            }
                            .frame(height: 250)
                            .frame(maxWidth: 300)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(spendingByCategory, id: \.category) { item in
                                    HStack {
                                        Text(item.category.rawValue)
                                            .font(.body)
                                        Spacer()
                                        Text(item.total, format: .currency(code: "USD"))
                                            .monospacedDigit()
                                        Text("(\(percentage(item.total))%)")
                                            .foregroundStyle(.secondary)
                                            .monospacedDigit()
                                    }
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Total")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(grandTotal, format: .currency(code: "USD"))
                                        .font(.headline)
                                        .monospacedDigit()
                                }
                            }
                            .frame(minWidth: 250)
                        }
                        .padding(.top, 8)
                    }
                }
                
                GroupBox("Daily Spending (Last 30 Days)") {
                    if dailySpending.isEmpty {
                        Text("No expenses to display")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 200)
                    }
                    else {
                        Chart(dailySpending, id: \.date) { item in
                            BarMark(
                                x: .value("Date", item.date, unit: .day),
                                y: .value("Amount", item.total)
                            )
                            .foregroundStyle(.blue.gradient)
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                        .padding(.top, 8)
                    }
                }
            }
            .padding()
        }
    }
    
    private func percentage(_ amount: Double) -> String {
        guard grandTotal > 0 else { return "0" }
        let pct = (amount / grandTotal) * 100
        
        return String(format: "%.1f", pct)
    }
}

#Preview {
    SpendingSummaryView()
        .modelContainer(for: Expense.self, inMemory: true)
}

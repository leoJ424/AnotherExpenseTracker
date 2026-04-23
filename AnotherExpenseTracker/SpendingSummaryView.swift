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
    
    @State private var windowOffset: Int = 0
    
    private let windowSize = 30
    
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
        let start = windowStart
        let end = windowEnd
        
        var totals: [Date: Double] = [:]
        for expense in expenses {
            let day = calendar.startOfDay(for: expense.date)
            guard day >= start && day <= end else { continue }
            totals[day, default: 0] += expense.amount
        }
        return totals
            .map{ (date: $0.key, total: $0.value) }
            .sorted{ $0.date < $1.date }
    }
    
    private var windowEnd: Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return calendar.date(byAdding: .day, value: -(windowOffset * windowSize), to: today)!
    }
    
    private var windowStart: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -(windowSize - 1), to: windowEnd)!
    }
    
    private var earliestExpenseDate: Date? {
        expenses.map(\.date).min()
    }
    
    private var canGoFurtherBack: Bool {
        guard let earliest = earliestExpenseDate else { return false }
        return windowStart > Calendar.current.startOfDay(for: earliest)
    }
    
    private var chartDomain: ClosedRange<Date> {
        let calendar = Calendar.current
        let paddingStart = calendar.date(byAdding: .hour, value: -24, to: windowStart)!
        let paddingEnd = calendar.date(byAdding: .hour, value: 24, to: windowEnd)!
        return paddingStart...paddingEnd
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
                
                GroupBox("Daily Spending") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Button {
                                windowOffset += 1
                            } label: {
                                Label("Previous 30 Days", systemImage: "chevron.left")
                            }
                            .disabled(!canGoFurtherBack)
                            
                            Spacer()
                            
                            Text("\(windowStart, format: .dateTime.month(.abbreviated).day()) - \(windowEnd, format: .dateTime.month(.abbreviated).day().year())")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                            
                            Spacer()
                            
                            Button {
                                windowOffset -= 1
                            } label: {
                                HStack {
                                    Text("Next 30 Days")
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .disabled(windowOffset == 0)
                        }
                        
                        
                        if dailySpending.isEmpty {
                            Text("No expenses in this window.")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 200)
                        } else {
                            Chart(dailySpending, id: \.date) { item in
                                BarMark(
                                    x: .value("Date", item.date, unit: .day),
                                    y: .value("Amount", item.total)
                                )
                                .foregroundStyle(.blue.gradient)
                                .cornerRadius(4)
                            }
                            .chartXScale(domain: chartDomain)
                            .frame(height: 200)
                        }
                    }
                    .padding(.top, 8)
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

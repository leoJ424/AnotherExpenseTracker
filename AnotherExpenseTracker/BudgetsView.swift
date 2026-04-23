//
//  BudgetsView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/23/26.
//

import SwiftUI
import SwiftData

struct BudgetsView: View {
    @Query private var budgets: [Budget]
    @Query private var expenses: [Expense]
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var editingCategory: Category?
    @State private var budgetToDelete: Budget?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            ForEach(Category.allCases) { category in
                BudgetRow(
                    category: category,
                    budget: budget(for: category),
                    spent: spent(for: category)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    editingCategory = category
                }
                .contextMenu {
                    if let existing = budget(for: category) {
                        Button("Edit") {
                            editingCategory = category
                        }
                        Button("Remove Budget", role: .destructive) {
                            budgetToDelete = existing
                            showingDeleteAlert = true
                        }
                    } else {
                        Button("Set Budget") {
                            editingCategory = category
                        }
                    }
                }
            }
        }
        .sheet(item: $editingCategory) { category in
            BudgetEditorSheet(category: category, existing: budget(for: category))
        }
        .alert("Remove Budget?", isPresented: $showingDeleteAlert) {
            Button("Remove", role: .destructive) {
                if let b = budgetToDelete {
                    modelContext.delete(b)
                    try? modelContext.save()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Spending in this category won't be tracked against a budget.")
        }
    }
    
    private func budget(for category: Category) -> Budget? {
        budgets.first(where: { $0.category == category })
    }
    
    private func spent(for category: Category) -> Double {
        let calendar = Calendar.current
        return expenses
            .filter{ $0.category == category && calendar.isDate($0.date, equalTo: .now, toGranularity: .month) }
            .reduce(0) { $0 + $1.amount }
    }
}

struct BudgetRow: View {
    let category: Category
    let budget: Budget?
    let spent: Double
    
    private var isOverBudget: Bool {
        guard let budget else { return false }
        return spent > budget.amount
    }
    
    private var progress: Double {
        guard let budget else { return 0 }
        guard budget.amount > 0 else { return spent > 0 ? 1.0 : 0 }
        return min(spent / budget.amount, 1.0)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName(for: category))
                .font(.title3)
                .frame(width: 28)
                .foregroundStyle(.tint)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(category.rawValue)
                        .font(.headline)
                    
                    Spacer()
                    
                    if let budget {
                        Text("\(spent, format: .currency(code: "USD")) of \(budget.amount, format: .currency(code: "USD"))")
                            .font(.callout)
                            .foregroundStyle(isOverBudget ? .red : .secondary)
                            .monospacedDigit()
                    } else {
                        Text("No budget set")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if budget != nil {
                    ProgressView(value: progress)
                        .tint(isOverBudget ? .red : .accentColor)
                }
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
    BudgetsView()
        .modelContainer(for: [Expense.self, Account.self, Budget.self], inMemory: true)
}

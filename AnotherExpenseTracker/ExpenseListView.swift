//
//  ExpenseListView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/16/26.
//

import SwiftUI
import SwiftData

enum DateRange: String, CaseIterable {
    case allTime = "All Time"
    case thisMonth = "This Month"
    case lastMonth = "Last Month"
}

struct ExpenseListView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @State private var showingAddSheet = false
    @State private var expenseToEdit: Expense?
    @State private var expenseToDelete: Expense?
    @State private var showingDeleteAlert = false
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State private var selectedCategory: Category?
    @State private var selectedDateRange: DateRange = .allTime
    
    private var filteredExpenses: [Expense] {
        expenses.filter { expense in
            let matchesSearch = searchText.isEmpty ||
                                expense.note.localizedCaseInsensitiveContains(searchText) ||
                                expense.category.rawValue.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedCategory == nil ||
                expense.category == selectedCategory
            
            let matchesDate: Bool
            switch selectedDateRange {
            case .allTime:
                matchesDate = true
            case .thisMonth:
                matchesDate = Calendar.current.isDate(expense.date, equalTo: .now, toGranularity: .month)
            case .lastMonth:
                let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
                matchesDate = Calendar.current.isDate(expense.date, equalTo: lastMonth, toGranularity: .month)
            }
            
            return matchesSearch && matchesCategory && matchesDate
        }
    }
    
    private var total: Double {
        filteredExpenses.reduce(0) { runningTotal, expense in
                runningTotal + expense.amount
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(filteredExpenses) { expense in
                    ExpenseRow(expense: expense)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            expenseToEdit = expense
                        }
                        .contextMenu {
                            Button("Edit") {
                                expenseToEdit = expense
                            }
                            Button("Delete", role: .destructive) {
                                expenseToDelete = expense
                                showingDeleteAlert = true
                            }
                        }
                }
            }
            .id("\(searchText.isEmpty)-\(String(describing: selectedCategory))-\(selectedDateRange)")
            .sheet(item: $expenseToEdit) { expense in
                    ExpenseEditorSheet(expense: expense)
            }
            .searchable(text: $searchText, prompt: "Search Expenses")
            
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
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Picker("Category", selection: $selectedCategory) {
                    Text("All Categories").tag(nil as Category?)
                    
                    Divider()
                    
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category as Category?)
                    }
                }
            }
            
            ToolbarItem(placement: .automatic) {
                Picker("Date Range", selection: $selectedDateRange) {
                    ForEach(DateRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            ExpenseEditorSheet()
        }
        .alert("Delete Expense?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let expense = expenseToDelete {
                    modelContext.delete(expense)
                    try? modelContext.save()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

struct ExpenseRow: View {
    let expense: Expense
    
    var body: some View {
        HStack(spacing: 12){
            // Left Section
            HStack(spacing: 12) {
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
                .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Middle Section
            Text(expense.account.name)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .center)
            
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(expense.amount, format: .currency(code: "USD"))
                    .font(.headline)
                    .monospacedDigit()
                Text(expense.date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .lineLimit(1)
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
        .modelContainer(for: [Expense.self, Account.self], inMemory: true)
}

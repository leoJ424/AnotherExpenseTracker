//
//  ExpenseEditorSheet.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/16/26.
//

import SwiftUI
import SwiftData

struct ExpenseEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Account.name) private var accounts: [Account]
    
    let expenseToEdit: Expense?
    
    @State private var amount: Double?
    @State private var date: Date
    @State private var category: Category
    @State private var note: String
    @State private var account: Account?
    
    private var isEditing: Bool {expenseToEdit != nil }
    
    private var isValid: Bool {
        guard let amount, amount > 0 else { return false }
        return account != nil
    }
    
    init(expense: Expense? = nil) {
        self.expenseToEdit = expense
        _amount = State(initialValue: expense?.amount)
        _date = State(initialValue: expense?.date ?? .now)
        _category = State(initialValue: expense?.category ?? .food)
        _note = State(initialValue: expense?.note ?? "")
        _account = State(initialValue: expense?.account)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(isEditing ? "Edit Expense" : "New Expense")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            Divider()
            
            Form {
                TextField("Amount", value: $amount, format: .currency(code: "USD"), prompt: Text("$0.00"))
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases, id:\.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                
                Picker("Account", selection: $account) {
                    Text("Select...").tag(Account?.none)
                    ForEach(accounts) { acc in
                        Text(acc.name).tag(acc as Account?)
                    }
                }
                
                TextField("Note", text: $note, prompt: Text("Optional"))
            }
            .formStyle(.grouped)
            .padding()
            
            Divider()
            
            HStack {
                Spacer()
                
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button(isEditing ? "Update" : "Save") {
                    save()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(!isValid)
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 400)
        .task {
            if account == nil {
                account = accounts.first(where: { $0.isDefault })
            }
        }
    }
    
    private func save() {
        guard let amount, let account else { return }
        
        if let expense = expenseToEdit {
            expense.amount = amount
            expense.date = date
            expense.category = category
            expense.note = note
            expense.account = account
        } else {
            let newExpense = Expense(
                amount: amount,
                date: date,
                category: category,
                note: note,
                account: account
            )
            modelContext.insert(newExpense)
        }
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    ExpenseEditorSheet()
        .modelContainer(for: [Expense.self, Account.self], inMemory: true)
}

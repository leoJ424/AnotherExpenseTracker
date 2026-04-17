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
    
    let expenseToEdit: Expense?
    
    @State private var amount: Double
    @State private var date: Date
    @State private var category: Category
    @State private var note: String
    
    private var isEditing: Bool {expenseToEdit != nil }
    
    private var isValid: Bool { amount > 0 }
    
    init(expense: Expense? = nil) {
        self.expenseToEdit = expense
        _amount = State(initialValue: expense?.amount ?? 0)
        _date = State(initialValue: expense?.date ?? .now)
        _category = State(initialValue: expense?.category ?? .food)
        _note = State(initialValue: expense?.note ?? "")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(isEditing ? "Edit Expense" : "New Expense")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            Divider()
            
            Form {
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases, id:\.self) { category in
                        Text(category.rawValue).tag(category)
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
    }
    
    private func save() {
        if let expense = expenseToEdit {
            expense.amount = amount
            expense.date = date
            expense.category = category
            expense.note = note
        } else {
            let newExpense = Expense(
                amount: amount,
                date: date,
                category: category,
                note: note
            )
            modelContext.insert(newExpense)
        }
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    ExpenseEditorSheet()
        .modelContainer(for: Expense.self, inMemory: true)
}

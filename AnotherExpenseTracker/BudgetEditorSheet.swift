//
//  BudgetEditorSheet.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/23/26.
//

import SwiftUI
import SwiftData

struct BudgetEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let category: Category
    let existing: Budget?
    
    @State private var amount: Double
    
    private var isEditing: Bool { existing != nil }
    private var isValid: Bool { amount >= 0 }
    
    init(category: Category, existing: Budget? = nil) {
        self.category = category
        self.existing = existing
        
        _amount = State(initialValue: existing?.amount ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(isEditing ? "Edit \(category.rawValue) Budget" : "Set \(category.rawValue) Budget")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            Divider()
            
            Form {
                TextField("Monthly Amount", value: $amount, format: .currency(code: "USD"))
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
                
                Button(isEditing ? "Update" : "Set"){
                    save()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(!isValid)
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 200)
    }
    
    private func save() {
        if let existing {
            existing.amount = amount
        } else {
            let newBudget = Budget(category: category, amount: amount)
            modelContext.insert(newBudget)
        }
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    BudgetEditorSheet(category: .food)
        .modelContainer(for: [Expense.self, Account.self, Budget.self], inMemory: true)
}

//
//  AddExpenseSheet.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/16/26.
//

import SwiftUI
import SwiftData

struct AddExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var amount: Double = 0
    @State private var date: Date = .now
    @State private var category: Category = .food
    @State private var note: String = ""
    
    private var isValid: Bool {
        amount > 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("New Expense")
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
                
                Button("Save") {
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
        let newExpense = Expense(
            amount: amount,
            date: date,
            category: category,
            note: note
        )
        modelContext.insert(newExpense)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    AddExpenseSheet()
}

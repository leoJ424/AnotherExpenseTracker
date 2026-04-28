//
//  RecurringExpenseEditorSheet.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/27/26.
//

import SwiftUI
import SwiftData

struct RecurringExpenseEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Account.name) private var accounts: [Account]
    
    let existing: RecurringExpense?
    
    @State private var amount: Double
    @State private var category: Category
    @State private var account: Account?
    @State private var note: String
    @State private var frequency: Frequency
    @State private var startDate: Date
    @State private var hasEndDate: Bool
    @State private var endDate: Date
    
    private var isEditing: Bool { existing != nil }
    
    private var isValid: Bool {
        amount > 0 &&
        account != nil &&
        (!hasEndDate || endDate >= startDate)
    }
    
    init(existing: RecurringExpense? = nil) {
        self.existing = existing
        
        _amount = State(initialValue: existing?.amount ?? 0)
        _category = State(initialValue: existing?.category ?? .bills)
        _account = State(initialValue: existing?.account)
        _note = State(initialValue: existing?.note ?? "")
        _frequency = State(initialValue: existing?.frequency ?? .monthly)
        _startDate = State(initialValue: existing?.startDate ?? .now)
        _hasEndDate = State(initialValue: existing?.endDate != nil)
        _endDate = State(initialValue: existing?.endDate ?? .now)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(isEditing ? "Edit Recurring Expense" : "New Recurring Expense")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            Divider()
            
            Form {
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
                
                Picker("Account", selection: $account) {
                    Text("Select...").tag(Account?.none)
                    ForEach(accounts) { acc in
                        Text(acc.name).tag(Account?.some(acc))
                    }
                }
                
                TextField("Note", text: $note)
                
                Picker("Frequency", selection: $frequency) {
                    ForEach(Frequency.allCases) { freq in
                        Text(freq.rawValue).tag(freq)
                    }
                }
                
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                
                Toggle("Has End Date", isOn: $hasEndDate)
                
                if hasEndDate {
                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: .date
                    )
                }
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
        .frame(minWidth: 480, minHeight: 500)
        .onAppear {
            if account == nil {
                account = accounts.first(where: { $0.isDefault })
            }
        }
    }
    
    private func save() {
        guard let account else { return }
        
        let finalEndDate: Date? = hasEndDate ? endDate : nil
        
        if let existing {
            existing.amount = amount
            existing.category = category
            existing.account = account
            existing.note = note
            existing.frequency = frequency
            existing.startDate = startDate
            existing.endDate = finalEndDate
        } else {
            let new = RecurringExpense(
                amount: amount,
                category: category,
                account: account,
                note: note,
                frequency: frequency,
                startDate: startDate,
                endDate: finalEndDate
            )
            modelContext.insert(new)
        }
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    RecurringExpenseEditorSheet()
        .modelContainer(for: [Expense.self, Account.self, Budget.self, RecurringExpense.self], inMemory: true)
}

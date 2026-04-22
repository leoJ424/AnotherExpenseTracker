//
//  AccountEditorSheet.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/22/26.
//

import SwiftUI
import SwiftData

struct AccountEditorSheet: View {
   
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let accountToEdit: Account?
    
    @State private var name: String
    @State private var type: AccountType
    
    private var isEditing: Bool { accountToEdit != nil }
    private var isValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }
    
    init(account: Account? = nil) {
        self.accountToEdit = account
        _name = State(initialValue: account?.name ?? "")
        _type = State(initialValue: account?.type ?? .checking)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(isEditing ? "Edit Account" : "New Account")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            
            Divider()
            
            Form {
                TextField("Name", text: $name, prompt: Text("Account name"))
                
                Picker("Type", selection: $type) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
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
        .frame(minWidth: 400, minHeight: 300)
    }
    
    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        
        if let account = accountToEdit {
            account.name = trimmedName
            account.type = type
        } else {
            let newAccount = Account(name: trimmedName, type: type)
            modelContext.insert(newAccount)
        }
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    AccountEditorSheet()
        .modelContainer(for: [Expense.self, Account.self], inMemory: true)
}

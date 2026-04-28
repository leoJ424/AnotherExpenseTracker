//
//  AccountListView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/22/26.
//

import SwiftUI
import SwiftData

struct AccountListView: View {
    
    @Query(sort: \Account.name) private var accounts: [Account]
    @Query private var expenses: [Expense]
    @Query private var recurringExpenses: [RecurringExpense]
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingAddSheet = false
    @State private var accountToEdit: Account?
    @State private var accountToDelete: Account?
    @State private var showingDeleteAlert = false
    @State private var showingBlockedDeleteAlert = false
    @State private var blockedReason = ""
    
    var body: some View {
        List {
            ForEach(accounts) { account in
                AccountRow(account: account,
                           expenseCount: expenseCount(for: account),
                           recurringCount: recurringCount(for: account)
                )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        accountToEdit = account
                    }
                    .contextMenu{
                        Button("Edit") {
                            accountToEdit = account
                        }
                        Button("Delete", role: .destructive) {
                            attemptDelete(account)
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Add Account", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AccountEditorSheet()
        }
        .sheet(item: $accountToEdit) { account in
            AccountEditorSheet(account: account)
        }
        .alert("Delete Account?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let account = accountToDelete {
                    modelContext.delete(account)
                    try? modelContext.save()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Cannot Delete", isPresented: $showingBlockedDeleteAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(blockedReason)
        }
    }
    
    private func expenseCount(for account: Account) -> Int {
        expenses.filter { $0.account == account }.count
    }
    
    private func recurringCount(for account: Account) -> Int {
        recurringExpenses.filter { $0.account == account }.count
    }
    
    private func attemptDelete(_ account: Account) {
        if account.isDefault {
            blockedReason = "The default account cannot be deleted."
            showingBlockedDeleteAlert = true
            return
        }
        let expenseCount = expenseCount(for: account)
        let recurringCount = recurringCount(for: account)
        if expenseCount > 0 || recurringCount > 0 {
            var parts: [String] = []
            if expenseCount > 0 {
                parts.append("\(expenseCount) expense\(expenseCount == 1 ? "" : "s")")
            }
            if recurringCount > 0 {
                parts.append("\(recurringCount) recurring schedule\(recurringCount == 1 ? "" : "s")")
            }
            let listed = parts.joined(separator: " and ")
            blockedReason = "This account has \(listed) linked to it. Reassign or delete them first."
            showingBlockedDeleteAlert = true
            return
        }
        accountToDelete = account
        showingDeleteAlert = true
    }
}

struct AccountRow: View {
    let account: Account
    let expenseCount: Int
    let recurringCount: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(account.name)
                        .font(.headline)
                    
                    if account.isDefault {
                        Text("Default")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.tint.opacity(0.2))
                            .foregroundStyle(.tint)
                            .clipShape(Capsule())
                    }
                }
                
                Text(account.type.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(expenseCount) expense\(expenseCount == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if recurringCount > 0 {
                    Text("\(recurringCount) recurring")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    AccountListView()
        .modelContainer(for: [Expense.self, Account.self], inMemory: true)
}

//
//  AnotherExpenseTrackerApp.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/9/26.
//

import SwiftUI
import SwiftData

@main
struct AnotherExpenseTrackerApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Expense.self, Account.self, Budget.self)
            seedIfNeeded(container.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup() {
            ContentView()
        }
        .modelContainer(for: [Expense.self, Account.self, Budget.self])
        .defaultSize(width: 900, height: 600)
        .windowResizability(.contentSize)
    }
    
    private func seedIfNeeded(_ context: ModelContext) {
        ensureDefaultAccount(context)
        
        let descriptor = FetchDescriptor<Expense>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        
        for account in Account.samples where !account.isDefault {
            context.insert(account)
        }
        
        for sample in Expense.samples {
            context.insert(sample)
        }
        try? context.save()
        print("Seeded \(Expense.samples.count) sample expenses and accounts.")
    }
    
    private func ensureDefaultAccount(_ context: ModelContext) {
        let descriptor = FetchDescriptor<Account> (
            predicate: #Predicate { $0.isDefault }
        )
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        
        if let defaultAccount = Account.samples.first(where: { $0.isDefault }) {
            context.insert(defaultAccount)
            try? context.save()
            print("Created default Cash account.")
        }
    }
}

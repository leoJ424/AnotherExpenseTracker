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
            container = try ModelContainer(for: Expense.self)
            seedIfNeeded(container.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup() {
            ContentView()
        }
        .modelContainer(for: Expense.self)
        .defaultSize(width: 900, height: 600)
        .windowResizability(.contentSize)
    }
    
    private func seedIfNeeded(_ context: ModelContext) {
        let descriptor = FetchDescriptor<Expense>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        
        for sample in Expense.samples {
            context.insert(sample)
        }
        try? context.save()
        print("Seeded \(Expense.samples.count) sample expenses  ")
    }
}

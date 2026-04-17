//
//  ContentView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/9/26.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        NavigationSplitView {
            // Sidebar content
            List {
                Label("Expenses", systemImage: "list.bullet")
            }
        }
        detail: {
            // Detail Pane
            ExpenseListView()
        }
    }
}

struct EmptyExpensesView: View {
    var body : some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No expenses yet")
                .font(.title2)
                .foregroundStyle(.secondary)
            Text("Add your first expense to get started.")
                .font(.callout)
                .foregroundStyle(.tertiary)
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

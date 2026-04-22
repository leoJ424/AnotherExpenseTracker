//
//  ContentView.swift
//  AnotherExpenseTracker
//
//  Created by Joel Mani Joseph Tharappel on 4/9/26.
//

import SwiftUI

enum SidebarItem: String, CaseIterable {
    case expenses = "Expenses"
    case summary = "Summary"
    
    var icon: String {
        switch self {
        case .expenses: return "list.bullet"
        case .summary: return "chart.pie"
        }
    }
}

struct ContentView : View {
    @State private var selectedItem: SidebarItem? = .expenses
    
    var body: some View {
        NavigationSplitView {
            // Sidebar content
            List(SidebarItem.allCases, id: \.self, selection: $selectedItem) { item in
                Label(item.rawValue, systemImage: item.icon)
            }
        } detail: {
            switch selectedItem {
            case .expenses:
                ExpenseListView()
            case .summary:
                SpendingSummaryView()
            case nil:
                Text("Select an item from the sidebar")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(minWidth: 700, minHeight: 400)
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

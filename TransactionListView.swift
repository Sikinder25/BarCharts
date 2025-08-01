//
//  TransactionListView.swift
//  chartstest
//
//  Created by M Kalyan Chakravarthy on 31/07/25.
//

import SwiftUI

struct TransactionListView: View {
    @State private var selectedSegment: String = "Latest"
    @Binding var rawSelectedDate: Date?
    var filteredTransactions: [CategoryData] {
            guard let selectedDate = rawSelectedDate,
                  let monthData = ViewMonth.filterByMonth(selectedDate) else {
                // If no date is selected, return all transactions
                return ViewMonth.mockData.first?.categoryData ?? []
            }
            
            // Filter transactions for the selected month
            return monthData.categoryData.filter {
                Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .month)
            }
        }
    
    var body: some View {
        VStack(alignment: .leading) {
            STSegmentedView(selected: $selectedSegment).frame(width: 200).padding()
            
            if selectedSegment == "Latest" {
                    List {
                        ForEach(filteredTransactions) { category in
                            TransactionRow(
                                icon: "cart.fill",
                                title: category.title,
                                status: "Today",
                                amount: "$\(String(format: "%.2f", category.value))",
                                date: category.date.description
                            )
                        }
                    }
                
                
            } else {
                List {
                
                    TransactionRow(icon: "cart.fill", title: "Apple", status: "Pending", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "cart.fill", title: "Amazon", status: "Pending", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "bag.fill", title: "Target", status: "Today", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "arrow.down.circle", title: "Deposit", status: "Feb 22", amount: "$500.00", date: nil)
                    TransactionRow(icon: "arrow.left.arrow.right", title: "Transfer from *3423", status: "Feb 22", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "cart.fill", title: "Amazon", status: "Pending", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "bag.fill", title: "Target", status: "Today", amount: "$00,000.00", date: nil)
                }
            }
        }
    }
}


struct TransactionRow: View {
    var icon: String
    var title: String
    var status: String
    var amount: String
    var date: String?

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 32, height: 32)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                Text(status)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(amount)
                    .font(.body)
                Text("$00.00")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Image(systemName: "arrow.right")
                .foregroundColor(.gray)
                
        }
    }
}

extension Date {
    var month: String {
        let names = Calendar.current.monthSymbols
        let month = Calendar.current.component(.month, from: self)
        return names[month - 1]
    }
}

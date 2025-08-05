//
//  Untitled.swift
//  chartstest
//
//  Created by M Kalyan Chakravarthy on 01/08/25.
//

import SwiftUI
import Charts

struct BarChartView<DataType: Identifiable>: View {
    let data: [DataType]
    let valueKeyPath: KeyPath<DataType, Double>
    let labelKeyPath: KeyPath<DataType, String>



    var body: some View {
            Chart(data) { item in
                BarMark(
                    x: .value("Label", item[keyPath: labelKeyPath]),
                    y: .value("Value", item[keyPath: valueKeyPath])
                )
                .foregroundStyle(.green)
            }
            .chartYAxis {
                AxisMarks(position: .trailing)
            }
            .frame(height: 250)
            .padding()
        }}

struct Spend: Identifiable {
    let id = UUID()
    let month: String
    let amount: Double
    let categoryColor: Color
    let week: String
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Double

    let monthString: String
//    let categoryData: [CategoryData] = [
//        .init(category: "Social", title: "Amazon", value: 1200, date: Date.from(year: 2024, month: 1, day: 1)),
//        .init(category: "Entertainment", title: "Target", value: 800, date: Date.from(year: 2024, month: 10, day: 1)),
//        .init(category: "Productivity & Finance", title: "Finance Apps", value: 600, date: Date.from(year: 2024, month: 4, day: 1)),
//        .init(category: "Other", title: "Walmart", value: 700, date: Date.from(year: 2024, month: 5, day: 1)),
//        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 7, day: 1)),
//        .init(category: "Social", title: "Miscellaneous", value: 100, date: Date.from(year: 2024, month: 1, day: 1)),
//        .init(category: "Entertainment", title: "Target", value: 900, date: Date.from(year: 2024, month: 3, day: 1)),
//        .init(category: "Productivity & Finance", title: "Finance Apps", value: 600, date: Date.from(year: 2024, month: 5, day: 1)),
//        .init(category: "Other", title: "Walmart", value: 400, date: Date.from(year: 2024, month: 6, day: 1)),
//        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 7, day: 1)),
//        .init(category: "Social", title: "Amazon", value: 1200, date: Date.from(year: 2024, month: 2, day: 1)),
//        .init(category: "Entertainment", title: "Target", value: 800, date: Date.from(year: 2024, month: 9, day: 1)),
//        .init(category: "Productivity & Finance", title: "Finance Apps", value: 600, date: Date.from(year: 2024, month: 2, day: 1)),
//        .init(category: "Other", title: "Walmart", value: 400, date: Date.from(year: 2024, month: 12, day: 1)),
//        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 11, day: 1)),
//        .init(category: "Other", title: "Walmart", value: 400, date: Date.from(year: 2024, month: 7, day: 1)),
//        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 9, day: 1))
//    ]

//    static func filterByMonth(_ date: Date) -> ViewMonth? {
//        return mockData.first {
//            Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month)
//        }
//    }
        

    
//    static let mockData: [ViewMonth] = [
//        .init(date: Date.from(year: 2024, month: 1, day: 1), viewCount: 55000, monthString: "Jan"),
//        .init(date: Date.from(year: 2024, month: 2, day: 1), viewCount: 89000, monthString: "Feb"),
//        .init(date: Date.from(year: 2024, month: 3, day: 1), viewCount: 64000,  monthString: "Mar"),
//        .init(date: Date.from(year: 2024, month: 4, day: 1), viewCount: 79000, monthString: "Apr"),
//        .init(date: Date.from(year: 2024, month: 5, day: 1), viewCount: 130000, monthString: "May"),
//        .init(date: Date.from(year: 2024, month: 6, day: 1), viewCount: 90000, monthString: "Jun"),
//        .init(date: Date.from(year: 2024, month: 7, day: 1), viewCount: 88000, monthString: "Jul"),
//        .init(date: Date.from(year: 2024, month: 8, day: 1), viewCount: 64000, monthString: "Aug"),
//        .init(date: Date.from(year: 2024, month: 9, day: 1), viewCount: 74000, monthString: "Sep"),
//        .init(date: Date.from(year: 2024, month: 10, day: 1), viewCount: 99000, monthString: "Oct"),
//        .init(date: Date.from(year: 2024, month: 11, day: 1), viewCount: 110000, monthString: "Nov"),
//        .init(date: Date.from(year: 2024, month: 12, day: 1), viewCount: 94000, monthString: "Dec")
//    ]
}

struct CategoryData: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let value: Double
    let date: Date
}

//
//  ContentView.swift
//  chartstest
//
//  Created by M Kalyan Chakravarthy on 18/07/25.
//

import SwiftUI
import Charts

enum ChartType {
    case line, bar, pie
}

enum ChartSelected: String, CaseIterable, Identifiable {
    case bar = "bar"
    case line = "line"
    case pie = "pie"

    var id: String { self.rawValue }
}

struct SpendingTrackerView: View {
    @State var selectedBtnData: ToggleButtonData = ToggleButtonData(name: "Bar", normalImageName: "star", selectedImageName: "star.fill", chartType: .bar)

    let buttons: [ToggleButtonData] = [
        ToggleButtonData(name: "Bar", normalImageName: "star", selectedImageName: "star.fill", chartType: .bar),
        ToggleButtonData(name: "Line", normalImageName: "heart", selectedImageName: "heart.fill", chartType: .line),
        ]
    
    let trackerData: [ViewMonth] = ViewMonth.mockData
    @State var rawSelectedDate: Date?
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
        NavigationStack {
            VStack {
                VStack {
                    HStack(alignment: .bottom){
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Spending tracker")
                                .font(.headline).padding(.bottom, 5)
                            Text("\(rawSelectedDate?.month ?? "This month") spending")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(filteredTransactions.reduce(0) { $0 + $1.value }, format: .currency(code: "USD"))
                                .font(.title)
                                .bold()
                        }.background(Color.clear)
                        Spacer()
                        SelectChatButtons(chartButtons: buttons, selectedBtnData: $selectedBtnData)
                            
                        .background(Color.clear)
                    }.padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading).background(Color.white)
                    if selectedBtnData.chartType == .bar {
                        STBarChart(rawSelectedDate: $rawSelectedDate)
                    } else {
                        STLineChart(rawSelectedDate: $rawSelectedDate)
                    }
                }.padding().background(Color.white).cornerRadius(10).padding()
                Spacer()
                
                TransactionListView(rawSelectedDate: $rawSelectedDate)
                    
                    
            }.background(Color.black.opacity(0.05))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.clear)
                
                .navigationTitle("Navigation").toolbarBackground(Color.blue, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(
                    Color.green,
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct SelectChatButtons: View {
    @State var chartButtons: [ToggleButtonData]
    //@State var selectedButtonId: UUID? = nil
    @Binding var selectedBtnData: ToggleButtonData
    
    var body: some View {
        HStack() {
            ForEach(chartButtons) { data in
                let isSelected = data.chartType == selectedBtnData.chartType ? true : false
                CustomToggleButton(buttonData: data, isSelected: isSelected) {
                    if self.selectedBtnData.chartType == data.chartType {
                        //self.selectedButtonId = nil // Deselect if already active
                        //selectedBtnData = nil
                    } else {
                        //self.selectedButtonId = data.id // Select this button
                        selectedBtnData = data // Update the selected button data
                    }
                }
            }
        }
    }
}



#Preview {
    SpendingTrackerView()
}

func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: seconds)) ?? Date()
}

extension Array {
    func appending(contentsOf: [Element]) -> Array {
        var a = Array(self)
        a.append(contentsOf: contentsOf)
        return a
    }
}

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: .now)
    }
}

extension Date {
    func nearestHour() -> Date? {
        var components = NSCalendar.current.dateComponents([.minute, .second, .nanosecond], from: self)
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        let nanosecond = components.nanosecond ?? 0
        components.minute = minute >= 30 ? 60 - minute : -minute
        components.second = -second
        components.nanosecond = -nanosecond
        return Calendar.current.date(byAdding: components, to: self)
    }
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Int
    let categoryData: [CategoryData] = [
        .init(category: "Social", title: "Amazon", value: 1200, date: Date.from(year: 2024, month: 1, day: 1)),
        .init(category: "Entertainment", title: "Target", value: 800, date: Date.from(year: 2024, month: 10, day: 1)),
        .init(category: "Productivity & Finance", title: "Finance Apps", value: 600, date: Date.from(year: 2024, month: 4, day: 1)),
        .init(category: "Other", title: "Walmart", value: 700, date: Date.from(year: 2024, month: 5, day: 1)),
        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 7, day: 1)),
        .init(category: "Social", title: "Miscellaneous", value: 100, date: Date.from(year: 2024, month: 1, day: 1)),
        .init(category: "Entertainment", title: "Target", value: 900, date: Date.from(year: 2024, month: 3, day: 1)),
        .init(category: "Productivity & Finance", title: "Finance Apps", value: 600, date: Date.from(year: 2024, month: 5, day: 1)),
        .init(category: "Other", title: "Walmart", value: 400, date: Date.from(year: 2024, month: 6, day: 1)),
        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 7, day: 1)),
        .init(category: "Social", title: "Amazon", value: 1200, date: Date.from(year: 2024, month: 2, day: 1)),
        .init(category: "Entertainment", title: "Target", value: 800, date: Date.from(year: 2024, month: 9, day: 1)),
        .init(category: "Productivity & Finance", title: "Finance Apps", value: 600, date: Date.from(year: 2024, month: 2, day: 1)),
        .init(category: "Other", title: "Walmart", value: 400, date: Date.from(year: 2024, month: 12, day: 1)),
        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 11, day: 1)),
        .init(category: "Other", title: "Walmart", value: 400, date: Date.from(year: 2024, month: 7, day: 1)),
        .init(category: "Other", title: "Miscellaneous", value: 400, date: Date.from(year: 2024, month: 9, day: 1))
    ]

    static func filterByMonth(_ date: Date) -> ViewMonth? {
        return mockData.first {
            Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month)
        }
    }
        

    
    static let mockData: [ViewMonth] = [
        .init(date: Date.from(year: 2024, month: 1, day: 1), viewCount: 55000),
        .init(date: Date.from(year: 2024, month: 2, day: 1), viewCount: 89000),
        .init(date: Date.from(year: 2024, month: 3, day: 1), viewCount: 64000),
        .init(date: Date.from(year: 2024, month: 4, day: 1), viewCount: 79000),
        .init(date: Date.from(year: 2024, month: 5, day: 1), viewCount: 130000),
        .init(date: Date.from(year: 2024, month: 6, day: 1), viewCount: 90000),
        .init(date: Date.from(year: 2024, month: 7, day: 1), viewCount: 88000),
        .init(date: Date.from(year: 2024, month: 8, day: 1), viewCount: 64000),
        .init(date: Date.from(year: 2024, month: 9, day: 1), viewCount: 74000),
        .init(date: Date.from(year: 2024, month: 10, day: 1), viewCount: 99000),
        .init(date: Date.from(year: 2024, month: 11, day: 1), viewCount: 110000),
        .init(date: Date.from(year: 2024, month: 12, day: 1), viewCount: 94000)
    ]
}

struct CategoryData: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let value: Double
    let date: Date
}


extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

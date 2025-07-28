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
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    HStack(alignment: .bottom){
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Spending tracker")
                                .font(.headline).padding(.bottom, 5)
                            Text("March spending")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("$5,270.58")
                                .font(.title)
                                .bold()
                        }.background(Color.clear)
                        Spacer()
                        SelectChatButtons(chartButtons: buttons, selectedBtnData: $selectedBtnData)
                            
                        .background(Color.clear)
                    }.padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading).background(Color.white)
                    if selectedBtnData.chartType == .bar {
                        SpendingChartView()
                    } else {
                        SpendingLineChartView()
                    }
                }.padding().background(Color.white).cornerRadius(10).padding()
                Spacer()
                
                TransactionListView()
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

struct SpendingChartView: View {

    @State var rawSelectedDate: Date?
    var selectedViewMonth: ViewMonth? {
        guard let rawSelectedDate else { return nil }
        return ViewMonth.mockData.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .month)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            Chart {
                ForEach(ViewMonth.mockData) { viewMonth in
                    BarMark(
                        x: .value("Month", viewMonth.date, unit: .month),
                        y: .value("Views", viewMonth.viewCount)
                    )
                    .foregroundStyle(Color.green.gradient)
                    .opacity(rawSelectedDate == nil || viewMonth.date == selectedViewMonth?.date ? 1 : 0.3)
                }
            }
            .frame(height: 200)
            .chartOverlay { proxy in
                
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { value in
                            let x = value.x - geo[proxy.plotAreaFrame].origin.x
                            if let date: Date = proxy.value(atX: x) {
                                rawSelectedDate = Calendar.current.startOfDay(for: date)

                            }
                        }
                }
            }
            
            NavigationLink("See More") {
                
            }
        }

        .background(Color.white)
    }
}

struct SpendingLineChartView: View {
   
    @State var rawSelectedDate: Date?
    var selectedViewMonth: ViewMonth? {
        guard let rawSelectedDate else { return nil }
        return ViewMonth.mockData.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .month)
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            Chart {
                ForEach(ViewMonth.mockData) { viewMonth in
                    LineMark(
                        x: .value("Month", viewMonth.date, unit: .month),
                        y: .value("Views", viewMonth.viewCount)
                    ).interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.green.gradient)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                            .offset(y: 0)
                    }
                }
            }
            .frame(height: 200)
            
            .chartOverlay { proxy in
                
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { value in
                            let x = value.x - geo[proxy.plotAreaFrame].origin.x
                            if let date: Date = proxy.value(atX: x) {
                                rawSelectedDate = Calendar.current.startOfDay(for: date)

                            }
                        }
                }
            }

            NavigationLink("See More") {
                
            }
        }

        .background(Color.white)
    }
}

struct TransactionListView: View {
    @State private var selectedSegment: String = "Latest"

    var body: some View {
        VStack(alignment: .leading) {
            STSegmentedView(selected: $selectedSegment).frame(width: 200).padding()
            
            if selectedSegment == "Latest" {
                List {
                    TransactionRow(icon: "cart.fill", title: "Walmart", status: "Pending", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "bag.fill", title: "Target", status: "Today", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "cart.fill", title: "Amazon", status: "Pending", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "bag.fill", title: "Target", status: "Today", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "arrow.down.circle", title: "Deposit", status: "Feb 22", amount: "$500.00", date: nil)
                    TransactionRow(icon: "arrow.left.arrow.right", title: "Transfer from *3423", status: "Feb 22", amount: "$00,000.00", date: nil)
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

#Preview {
    SpendingTrackerView()
}
enum ScreenTimeCategory: String, Plottable {
    case social = "Social"
    case entertainment = "Entertainment"
    case productivityFinance = "Productivity & Finance"
    case other = "Other"

    var index: Int {
        switch self {
        case .social:
            return 0
        case .entertainment:
            return 1
        case .productivityFinance:
            return 2
        case .other:
            return 3
        }
    }
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


extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}

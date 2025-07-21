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

struct SpendingTrackerView: View {
    @State private var currentChart: ChartType = .bar
    
    var body: some View {
        NavigationStack {
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
                    HStack() {
                        Button("Bar") {
                            currentChart = .bar
                        }.buttonStyle(.bordered)
                        
                        Button("Line") {
                            currentChart = .line
                        }.buttonStyle(.bordered)
                    }
                    .background(Color.clear)
                }.padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading).background(Color.clear)
                if currentChart == .bar {
                    SpendingChartView()
                } else {
                    SpendingLineChartView()
                }
                Spacer()
                
                TransactionListView().padding(.top, 20)

            }
            
            
                
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
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
    var body: some View {
        VStack(alignment: .leading) {
            SegmentedView().frame(width: 200).padding(.bottom, 16)
            ScrollView {
                VStack(spacing: 16) {
                    TransactionRow(icon: "cart.fill", title: "Amazon", status: "Pending", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "bag.fill", title: "Target", status: "Today", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "arrow.down.circle", title: "Deposit", status: "Feb 22", amount: "$500.00", date: nil)
                    TransactionRow(icon: "arrow.left.arrow.right", title: "Transfer from *3423", status: "Feb 22", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "cart.fill", title: "Amazon", status: "Pending", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "bag.fill", title: "Target", status: "Today", amount: "$00,000.00", date: nil)
                    TransactionRow(icon: "arrow.down.circle", title: "Deposit", status: "Feb 22", amount: "$500.00", date: nil)
                    TransactionRow(icon: "arrow.left.arrow.right", title: "Transfer from *3423", status: "Feb 22", amount: "$00,000.00", date: nil)
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
        }
    }
}

struct SegmentedView: View {

    let segments: [String] = ["Latest", "Schedule"]
    @State private var selected: String = "Latest"
    @Namespace var name

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button {
                    selected = segment
                } label: {
                    VStack {
                        Text(segment)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(selected == segment ? .green : Color(uiColor: .systemGray))
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if selected == segment {
                                Capsule()
                                    .fill(Color.green)
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
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

struct ScreenTimeValue: Identifiable {
    let valueDate: Date
    let category: ScreenTimeCategory
    var duration: TimeInterval

    var id: Date { valueDate }
}

extension ScreenTimeValue {
    static var week: [ScreenTimeValue] = []
        .appending(contentsOf: Self.monday)
        .appending(contentsOf: Self.tuesday)
        .appending(contentsOf: Self.wednesday)
        .appending(contentsOf: Self.thursday)
        .appending(contentsOf: Self.friday)
        .appending(contentsOf: Self.saturday)
        .appending(contentsOf: Self.sunday)

    static var monday: [ScreenTimeValue] = [
        // 12 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 00), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 00), category: .other, duration: 33*60),
        // 1 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 01), category: .social, duration: 16*60),
        // 6 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 06), category: .social, duration: 12*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 06), category: .other, duration: 2*60),
        // 7 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .social, duration: 32*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .entertainment, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .productivityFinance, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 07), category: .other, duration: 2*60),
        // 8 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 08), category: .social, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 08), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 08), category: .other, duration: 3*60),
        // 9 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 09), category: .social, duration: 7*60),
        // 11 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 11), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 11), category: .other, duration: 60),
        // 12 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 12), category: .social, duration: 35*60),
        // 1 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 13), category: .social, duration: 7*60),
        // 2 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 14), category: .social, duration: 6*60),
        // 3 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 15), category: .social, duration: 5*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 15), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 15), category: .other, duration: 2*60),
        // 4 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 16), category: .social, duration: 38*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 16), category: .entertainment, duration: 60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 16), category: .other, duration: 3*60),
        // 5 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 17), category: .social, duration: 27*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 17), category: .entertainment, duration: 20*60),
        // 6 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 18), category: .social, duration: 22*60),
        // 7 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 19), category: .social, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 19), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 19), category: .other, duration: 2*60),
        // 8 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 20), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 20), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 20), category: .other, duration: 13*60),
        // 9 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .social, duration: 11*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .productivityFinance, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 21), category: .other, duration: 5*60),
        // 10 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 22), category: .productivityFinance, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 22), category: .other, duration: 60),
        // 11 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 23), category: .social, duration: 28*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 20, hour: 23), category: .productivityFinance, duration: 2*60),
    ]
    static var tuesday: [ScreenTimeValue] = [
        // 12 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 00), category: .social, duration: 5*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 00), category: .other, duration: 30),
        // 6 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 06), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 06), category: .other, duration: 60),
        // 7 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 07), category: .social, duration: 14*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 07), category: .other, duration: 60),
        // 8 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 08), category: .social, duration: 8*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 08), category: .other, duration: 2*60),
        // 10 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 10), category: .social, duration: 30),
        // 11 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 11), category: .social, duration: 5*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 11), category: .other, duration: 60),
        // 12 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 12), category: .social, duration: 8*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 12), category: .social, duration: 30),
        // 4 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 16), category: .social, duration: 2*60),
        // 5 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 17), category: .social, duration: 8*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 17), category: .other, duration: 60),
        // 6 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 18), category: .social, duration: 16*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 18), category: .entertainment, duration: 29*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 18), category: .productivityFinance, duration: 12*60),
//        // 7 PM
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 19), category: .social, duration: 9*60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 19), category: .entertainment, duration: 5*60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 19), category: .other, duration: 60),
        // 8 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 20), category: .social, duration: 10*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 20), category: .productivityFinance, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 20), category: .other, duration: 11*60),
        // 9 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 21), category: .social, duration: 8*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 21), category: .entertainment, duration: 3*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 21), category: .other, duration: 30*60),
        // 10 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 22), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 22), category: .other, duration: 43*60),
        // 11 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 23), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 23), category: .entertainment, duration: 35*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 21, hour: 23), category: .other, duration: 8*60),
    ]
    static var wednesday: [ScreenTimeValue] = [
        // 12 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 00), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 00), category: .other, duration: 33*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 01), category: .social, duration: 16*60),
        // 6 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 06), category: .social, duration: 12*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 06), category: .other, duration: 2*60),
        // 7 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .social, duration: 32*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .entertainment, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .productivityFinance, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 07), category: .other, duration: 2*60),
        // 8 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 08), category: .social, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 08), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 08), category: .other, duration: 3*60),
        // 9 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 09), category: .social, duration: 7*60),
        // 11 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 11), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 11), category: .other, duration: 60),
        // 12 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 12), category: .social, duration: 35*60),
        // 1 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 13), category: .social, duration: 7*60),
        // 2 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 14), category: .social, duration: 6*60),
        // 3 PM
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 15), category: .social, duration: 5*60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 15), category: .entertainment, duration: 30),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 15), category: .other, duration: 2*60),
//        // 4 PM
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 16), category: .social, duration: 38*60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 16), category: .entertainment, duration: 60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 16), category: .other, duration: 3*60),
        // 5 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 17), category: .social, duration: 27*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 17), category: .entertainment, duration: 20*60),
        // 6 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 18), category: .social, duration: 22*60),
        // 7 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 19), category: .social, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 19), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 19), category: .other, duration: 2*60),
        // 8 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 20), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 20), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 20), category: .other, duration: 13*60),
        // 9 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .social, duration: 11*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .productivityFinance, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 21), category: .other, duration: 5*60),
        // 10 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 22), category: .productivityFinance, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 22), category: .other, duration: 60),
        // 11 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 23), category: .social, duration: 28*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 22, hour: 23), category: .productivityFinance, duration: 2*60),
    ]
    static var thursday: [ScreenTimeValue] = [
        // 12 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 00), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 00), category: .other, duration: 33*60),
        // 1 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 01), category: .social, duration: 16*60),
        // 6 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 06), category: .social, duration: 12*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 06), category: .other, duration: 2*60),
        // 7 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .social, duration: 32*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .entertainment, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .productivityFinance, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 07), category: .other, duration: 2*60),
        // 8 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 08), category: .social, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 08), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 08), category: .other, duration: 3*60),
        // 9 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 09), category: .social, duration: 7*60),
        // 11 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 11), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 11), category: .other, duration: 60),
        // 12 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 12), category: .social, duration: 35*60),
        // 1 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 13), category: .social, duration: 7*60),
        // 2 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 14), category: .social, duration: 6*60),
        // 3 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 15), category: .social, duration: 5*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 15), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 15), category: .other, duration: 2*60),
        // 4 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 16), category: .social, duration: 38*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 16), category: .entertainment, duration: 60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 16), category: .other, duration: 3*60),
        // 5 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 17), category: .social, duration: 27*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 17), category: .entertainment, duration: 20*60),
        // 6 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 18), category: .social, duration: 22*60),
        // 7 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 19), category: .social, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 19), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 19), category: .other, duration: 2*60),
        // 8 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 20), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 20), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 20), category: .other, duration: 13*60),
        // 9 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .social, duration: 11*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .productivityFinance, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 21), category: .other, duration: 5*60),
        // 10 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 22), category: .productivityFinance, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 22), category: .other, duration: 60),
        // 11 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 23), category: .social, duration: 28*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 23, hour: 23), category: .productivityFinance, duration: 2*60),
    ]
    static var friday: [ScreenTimeValue] = [
        // 12 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 00), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 00), category: .other, duration: 33*60),
        // 1 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 01), category: .social, duration: 16*60),
        // 6 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 06), category: .social, duration: 12*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 06), category: .other, duration: 2*60),
        // 7 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .social, duration: 32*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .entertainment, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .productivityFinance, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 07), category: .other, duration: 2*60),
        // 8 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 08), category: .social, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 08), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 08), category: .other, duration: 3*60),
        // 9 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 09), category: .social, duration: 7*60),
        // 11 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 11), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 11), category: .other, duration: 60),
        // 12 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 12), category: .social, duration: 35*60),
        // 1 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 13), category: .social, duration: 7*60),
        // 2 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 14), category: .social, duration: 6*60),
        // 3 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 15), category: .social, duration: 5*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 15), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 15), category: .other, duration: 2*60),
        // 4 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 16), category: .social, duration: 38*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 16), category: .entertainment, duration: 60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 16), category: .other, duration: 3*60),
        // 5 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 17), category: .social, duration: 27*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 17), category: .entertainment, duration: 20*60),
        // 6 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 18), category: .social, duration: 22*60),
        // 7 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 19), category: .social, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 19), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 19), category: .other, duration: 2*60),
        // 8 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 20), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 20), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 20), category: .other, duration: 13*60),
        // 9 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .social, duration: 11*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .productivityFinance, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 21), category: .other, duration: 5*60),
        // 10 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 22), category: .productivityFinance, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 22), category: .other, duration: 60),
        // 11 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 23), category: .social, duration: 28*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 24, hour: 23), category: .productivityFinance, duration: 2*60),
    ]
    static var saturday: [ScreenTimeValue] = [
        // 12 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 00), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 00), category: .other, duration: 33*60),
        // 1 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 01), category: .social, duration: 16*60),
//        // 6 AM
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 06), category: .social, duration: 12*60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 06), category: .other, duration: 2*60),
//        // 7 AM
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .social, duration: 32*60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .entertainment, duration: 2*60),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .productivityFinance, duration: 30),
//        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 07), category: .other, duration: 2*60),
        // 8 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 08), category: .social, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 08), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 08), category: .other, duration: 3*60),
        // 9 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 09), category: .social, duration: 7*60),
        // 11 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 11), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 11), category: .other, duration: 60),
        // 12 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 12), category: .social, duration: 35*60),
        // 1 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 13), category: .social, duration: 7*60),
        // 2 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 14), category: .social, duration: 6*60),
        // 3 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 15), category: .social, duration: 5*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 15), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 15), category: .other, duration: 2*60),
        // 4 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 16), category: .social, duration: 38*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 16), category: .entertainment, duration: 60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 16), category: .other, duration: 3*60),
        // 5 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 17), category: .social, duration: 27*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 17), category: .entertainment, duration: 20*60),
        // 6 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 18), category: .social, duration: 22*60),
        // 7 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 19), category: .social, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 19), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 19), category: .other, duration: 2*60),
        // 8 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 20), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 20), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 20), category: .other, duration: 13*60),
        // 9 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .social, duration: 11*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .productivityFinance, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 21), category: .other, duration: 5*60),
        // 10 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 22), category: .productivityFinance, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 22), category: .other, duration: 60),
        // 11 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 23), category: .social, duration: 28*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 25, hour: 23), category: .productivityFinance, duration: 2*60),
    ]
    static var sunday: [ScreenTimeValue] = [
        // 12 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 00), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 00), category: .other, duration: 33*60),
        // 1 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 01), category: .social, duration: 16*60),
        // 6 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 06), category: .social, duration: 12*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 06), category: .other, duration: 2*60),
        // 7 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .social, duration: 32*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .entertainment, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .productivityFinance, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 07), category: .other, duration: 2*60),
        // 8 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 08), category: .social, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 08), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 08), category: .other, duration: 3*60),
        // 9 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 09), category: .social, duration: 7*60),
        // 11 AM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 11), category: .social, duration: 25*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 11), category: .other, duration: 60),
        // 12 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 12), category: .social, duration: 35*60),
        // 1 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 13), category: .social, duration: 7*60),
        // 2 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 14), category: .social, duration: 6*60),
        // 3 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 15), category: .social, duration: 5*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 15), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 15), category: .other, duration: 2*60),
        // 4 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 16), category: .social, duration: 38*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 16), category: .entertainment, duration: 60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 16), category: .other, duration: 3*60),
        // 5 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 17), category: .social, duration: 27*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 17), category: .entertainment, duration: 20*60),
        // 6 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 18), category: .social, duration: 22*60),
        // 7 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 19), category: .social, duration: 2*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 19), category: .entertainment, duration: 30),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 19), category: .other, duration: 2*60),
        // 8 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 20), category: .social, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 20), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 20), category: .other, duration: 13*60),
        // 9 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .social, duration: 11*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .entertainment, duration: 13*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .productivityFinance, duration: 15*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 21), category: .other, duration: 5*60),
        // 10 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 22), category: .productivityFinance, duration: 17*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 22), category: .other, duration: 60),
        // 11 PM
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 23), category: .social, duration: 28*60),
        ScreenTimeValue(valueDate: date(year: 2022, month: 06, day: 26, hour: 23), category: .productivityFinance, duration: 2*60),
    ]
}
func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: seconds)) ?? Date()
}

enum Constants {
    static let previewChartHeight: CGFloat = 100
    static let detailChartHeight: CGFloat = 300
}

extension Array where Element == ScreenTimeValue {
    func makeDayValues() -> [ScreenTimeValue] {

        let days = Dictionary(grouping: self, by: { Calendar.current.startOfDay(for: $0.valueDate) })

        return days.reduce([ScreenTimeValue]()) { partialResult, day in
            var result = partialResult
            day.value.forEach({ value in
                if let index = result.firstIndex(where: { ($0.category == value.category) && (Calendar.current.isDate($0.valueDate, inSameDayAs: day.key)) }) {
                    result[index].duration += value.duration
                } else {
                    result.append(ScreenTimeValue(valueDate: day.key, category: value.category, duration: value.duration))
                }
            })
            return result.sorted(by: { $0.category.index < $1.category.index })
        }
    }
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

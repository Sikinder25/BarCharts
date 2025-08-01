//
//  STBarChart.swift
//  chartstest
//
//  Created by M Kalyan Chakravarthy on 31/07/25.
//
import SwiftUI
import Charts

struct STBarChart: View {

    @Binding var rawSelectedDate: Date?
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

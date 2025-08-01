//
//  SegmentedView.swift
//  chartstest
//
//  Created by M Kalyan Chakravarthy on 27/07/25.
//

import SwiftUI

struct STSegmentedView: View {

    let segments: [String] = ["Latest", "Schedule"]
    @Binding var selected: String
    @Namespace var name

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button {
                    selected = segment
                } label: {
                    VStack {
                        HStack {
                            Text(segment)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(selected == segment ? .green : Color(uiColor: .systemGray))
                            RedBadge(count: 5)
                        }
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 1)
                            if selected == segment {
                                Capsule()
                                    .fill(Color.green)
                                    .frame(height: 3)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
        }
            
    }
}

struct RedBadge: View {
    var count: Int

    var body: some View {
        Text("\(count)")
            .font(.caption2)
            .foregroundColor(.white)
            .padding(6)
            .background(Color.red)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 1)
            )
    }
}

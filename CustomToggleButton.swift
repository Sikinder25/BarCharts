//
//  Cust.swift
//  chartstest
//
//  Created by M Kalyan Chakravarthy on 19/07/25.
//
import SwiftUI

struct ToggleButtonData: Identifiable, Equatable {
    let id = UUID() // Unique identifier for ForEach
    let name: String // A name for the button (optional, but good for debugging)
    let normalImageName: String // SF Symbol name or asset name for unselected state
    let selectedImageName: String // SF Symbol name or asset name for selected state
    let chartType:ChartType
}

struct CustomToggleButton: View {
    let buttonData: ToggleButtonData
    let isSelected: Bool // This button's current selection state
    let action: () -> Void // Action to perform when tapped
    private var buttonImageContent: some View {
            Image(systemName: isSelected ? buttonData.selectedImageName : buttonData.normalImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundColor(isSelected ? .blue : .gray)
    }

    var body: some View {
        Button(action: action) {
            buttonImageContent
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling if desired
    }
}

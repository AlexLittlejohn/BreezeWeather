//
//  Modifiers.swift
//  Breeze
//
//  Created by Alex Littlejohn on 26/04/2020.
//  Copyright © 2020 zero. All rights reserved.
//

import SwiftUI

struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(.horizontal, Measurements.medium)
            .padding(.vertical, Measurements.small + Measurements.smaller)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: Measurements.medium, style: .continuous))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, Measurements.medium)
            .padding(.vertical, Measurements.small + Measurements.smaller)
            .font(Font.system(size: 14, weight: .semibold))
            .foregroundColor(Color.white)
            .background(Color(.systemBlue))
            .clipShape(RoundedRectangle(cornerRadius: Measurements.medium, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct CardButtonStyle: ButtonStyle {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(Measurements.large)
            .foregroundColor(Color(.label))
            .background(Color(colorScheme == .dark ? .secondarySystemBackground : .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: Measurements.large, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: colorScheme == .dark ? 0 : Measurements.small, x: 0, y: 0)
            .scaleEffect(configuration.isPressed ? 0.975 : 1.0)
    }
}

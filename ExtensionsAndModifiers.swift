//
//  Extensions.swift
//  BasicList
//
//  Created by Travis Domenic Ratliff on 1/24/24.
//

import Foundation
import SwiftUI
import SwiftData

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

extension View {
    func viewModifier() -> some View {
        modifier(Modifier())
    }
    func categoryHeadline() -> some View {
        modifier(TextModifier())
    }
    func buttonColor() -> some View {
        modifier(ButtonModifier())
    }
}

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct Modifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(Color(hex: colorScheme == .light ? "f6eee3" : "232323"))
            .cornerRadius(10)
            .padding(15)
    }
}

struct TextModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? .black : .white)
            .fontWeight(.regular)
    }
}

struct ButtonModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(colorScheme == .light ? .black : .white)
    }
}

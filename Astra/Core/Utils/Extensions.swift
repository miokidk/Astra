//
//  Extensions.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

extension Color {
    init?(hex: String, alpha: Double = 1.0) {
        var formatted = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }

        guard formatted.count == 6,
              let value = UInt64(formatted, radix: 16) else {
            return nil
        }

        let red = Double((value >> 16) & 0xff) / 255.0
        let green = Double((value >> 8) & 0xff) / 255.0
        let blue = Double(value & 0xff) / 255.0
        self = Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension View {
    @ViewBuilder
    func optionalOverlay<Overlay: View>(_ overlay: Overlay?, alignment: Alignment = .center) -> some View {
        if let overlay {
            self.overlay(overlay, alignment: alignment)
        } else {
            self
        }
    }
}

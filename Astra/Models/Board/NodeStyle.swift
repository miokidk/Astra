//
//  NodeStyle.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct NodeStyle: Codable, Equatable {
    var backgroundHex: String
    var accentHex: String
    var cornerRadius: CGFloat

    var backgroundColor: Color {
        if let color = Color(hex: backgroundHex) {
            return color
        }
#if canImport(UIKit)
        return Color(.systemBackground)
#elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor)
#else
        return Color.white
#endif
    }

    var accentColor: Color {
        Color(hex: accentHex) ?? .accentColor
    }

    static let textDefault = NodeStyle(backgroundHex: "FFFFFF", accentHex: "5B8DEF", cornerRadius: 16)
    static let imageDefault = NodeStyle(backgroundHex: "101820", accentHex: "F3D250", cornerRadius: 20)
    static let shapeDefault = NodeStyle(backgroundHex: "F0F4FF", accentHex: "4C8BF5", cornerRadius: 24)
}

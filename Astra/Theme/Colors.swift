//
//  Colors.swift
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

enum AstraColors {
    static let canvas: Color = {
#if canImport(UIKit)
        return Color(.systemGray6)
#elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor)
#else
        return Color.gray.opacity(0.15)
#endif
    }()

    static let panelBackground: Color = {
#if canImport(UIKit)
        return Color(.secondarySystemBackground)
#elseif canImport(AppKit)
        return Color(nsColor: .underPageBackgroundColor)
#else
        return Color.gray.opacity(0.2)
#endif
    }()

    static let accent = Color.accentColor
}

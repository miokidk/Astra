//
//  PaletteViewModel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

final class PaletteViewModel: ObservableObject {
    @Published var availableStyles: [NodeStyle]
    @Published var selectedStyle: NodeStyle

    init(availableStyles: [NodeStyle] = [.textDefault, .imageDefault, .shapeDefault],
         selectedStyle: NodeStyle? = nil) {
        self.availableStyles = availableStyles
        self.selectedStyle = selectedStyle ?? availableStyles.first ?? .textDefault
    }

    func select(style: NodeStyle) {
        selectedStyle = style
    }
}

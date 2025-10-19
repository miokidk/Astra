//
//  PaletteView.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct PaletteView: View {
    @ObservedObject var viewModel: PaletteViewModel

    var body: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.availableStyles, id: \.accentHex) { style in
                Circle()
                    .fill(style.accentColor)
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(style == viewModel.selectedStyle ? 0.8 : 0.2), lineWidth: 2)
                    )
                    .shadow(radius: style == viewModel.selectedStyle ? 6 : 0)
                    .onTapGesture {
                        viewModel.select(style: style)
                    }
            }
        }
        .padding(8)
        .background(.thinMaterial, in: Capsule(style: .continuous))
    }
}

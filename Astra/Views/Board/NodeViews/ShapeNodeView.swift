//
//  ShapeNodeView.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct ShapeNodeView: View {
    let node: BoardNode

    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: node.style.cornerRadius, style: .continuous)
                .fill(node.style.accentColor.opacity(0.2))
                .frame(width: 120, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: node.style.cornerRadius, style: .continuous)
                        .stroke(node.style.accentColor, lineWidth: 2)
                )

            Text(node.title)
                .font(.headline)
                .foregroundColor(node.style.accentColor)

            Text(node.body)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .padding(16)
        .background(node.style.backgroundColor, in: RoundedRectangle(cornerRadius: node.style.cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 10, y: 4)
    }
}

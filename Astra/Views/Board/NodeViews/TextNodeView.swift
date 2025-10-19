//
//  TextNodeView.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct TextNodeView: View {
    let node: BoardNode

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(node.title)
                .font(.headline)
                .foregroundColor(node.style.accentColor)
            Text(node.body)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(minWidth: 180, alignment: .leading)
        .background(node.style.backgroundColor, in: RoundedRectangle(cornerRadius: node.style.cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 12, y: 6)
    }
}

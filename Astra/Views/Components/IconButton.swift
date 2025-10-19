//
//  IconButton.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct IconButton: View {
    let systemName: String
    let action: () -> Void
    var tint: Color = .accentColor

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .padding(8)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .tint(tint)
    }
}

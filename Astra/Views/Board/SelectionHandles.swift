//
//  SelectionHandles.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct SelectionHandles: View {
    let style: NodeStyle

    var body: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius + 4, style: .continuous)
            .stroke(style.accentColor.opacity(0.9), lineWidth: 3)
            .padding(-6)
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(style.accentColor)
                    .frame(width: 10, height: 10)
                    .offset(x: 6, y: -6)
            }
            .overlay(alignment: .bottomLeading) {
                Circle()
                    .fill(style.accentColor)
                    .frame(width: 10, height: 10)
                    .offset(x: -6, y: 6)
            }
    }
}

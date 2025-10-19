//
//  LinkText.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct LinkText: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.callout.weight(.medium))
                .foregroundColor(.accentColor)
                .underline()
        }
        .buttonStyle(.plain)
    }
}

//
//  ConversationPanel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct ConversationPanel: View {
    @ObservedObject var viewModel: ConversationPanelViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.conversation.topic)
                .font(.title2.weight(.semibold))

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.conversation.messages) { message in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message.role.rawValue.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(message.text)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding(12)
                        .background(AstraColors.panelBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
        .padding(20)
        .frame(minWidth: 260, idealWidth: 320, maxWidth: 360)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 12)
    }
}

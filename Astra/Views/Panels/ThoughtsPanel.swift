//
//  ThoughtsPanel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct ThoughtsPanel: View {
    @ObservedObject var viewModel: ThoughtsPanelViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Thoughts")
                .font(.title3.weight(.bold))

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.thoughts) { thought in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(thought.title)
                                .font(.headline)
                            Text(thought.detail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(12)
                        .background(AstraColors.panelBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
        .padding(20)
        .frame(minWidth: 240, idealWidth: 300, maxWidth: 340)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 12)
    }
}

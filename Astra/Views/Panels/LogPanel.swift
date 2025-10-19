//
//  LogPanel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct LogPanel: View {
    @ObservedObject var viewModel: LogPanelViewModel
    var linkAction: (LogLink) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Activity Log")
                    .font(.title3.weight(.bold))
                Spacer()
                Button("Clear") {
                    viewModel.clear()
                }
                .buttonStyle(.borderless)
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.events) { event in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.message)
                                .font(.body)
                            Text(event.timestamp, style: .time)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            if let link = event.link {
                                LinkText(title: "View") {
                                    linkAction(link)
                                }
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AstraColors.panelBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
        .padding(20)
        .frame(minWidth: 260, idealWidth: 320, maxWidth: 340)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 12)
    }
}

//
//  TopLeftButtons.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct TopLeftButtons: View {
    @ObservedObject var panelCoordinator: PanelCoordinator

    var body: some View {
        HStack(spacing: 8) {
            IconButton(systemName: "text.bubble") {
                panelCoordinator.toggleConversation()
            }

            IconButton(systemName: "lightbulb") {
                panelCoordinator.toggleThoughts()
            }

            IconButton(systemName: "list.bullet.rectangle") {
                panelCoordinator.toggleLog()
            }
        }
    }
}

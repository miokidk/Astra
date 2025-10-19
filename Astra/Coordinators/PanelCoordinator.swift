//
//  PanelCoordinator.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

final class PanelCoordinator: ObservableObject {
    @Published var isConversationVisible: Bool = false
    @Published var isThoughtsVisible: Bool = false
    @Published var isLogVisible: Bool = false

    func hideAll() {
        isConversationVisible = false
        isThoughtsVisible = false
        isLogVisible = false
    }

    func toggleConversation() {
        let newValue = !isConversationVisible
        hideAll()
        isConversationVisible = newValue
    }

    func showConversation() {
        hideAll()
        isConversationVisible = true
    }

    func toggleThoughts() {
        let newValue = !isThoughtsVisible
        hideAll()
        isThoughtsVisible = newValue
    }

    func showThoughts() {
        hideAll()
        isThoughtsVisible = true
    }

    func toggleLog() {
        let newValue = !isLogVisible
        hideAll()
        isLogVisible = newValue
    }

    func showLog() {
        hideAll()
        isLogVisible = true
    }
}

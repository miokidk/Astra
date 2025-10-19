//
//  ConversationPanelViewModel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

final class ConversationPanelViewModel: ObservableObject {
    @Published private(set) var conversation: Conversation

    private let engine: AstraEngine

    init(conversation: Conversation = .sample, engine: AstraEngine) {
        self.conversation = conversation
        self.engine = engine
    }

    func appendMessage(role: MessageRole, text: String) {
        let message = Message(role: role, text: text)
        conversation.messages.append(message)
    }

    func summarize() -> Thought {
        engine.summarizeConversation(conversation)
    }
}

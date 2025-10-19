//
//  Conversation.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

struct Conversation: Identifiable, Codable {
    var id: ConversationID
    var topic: String
    var messages: [Message]

    static let sample = Conversation(
        id: ConversationID(),
        topic: "Kickoff",
        messages: [
            Message(role: .system, text: "Welcome to Astra's collaborative canvas."),
            Message(role: .user, text: "Capture product vision and research tasks."),
            Message(role: .assistant, text: "Drafted starter nodes with priorities.")
        ]
    )
}

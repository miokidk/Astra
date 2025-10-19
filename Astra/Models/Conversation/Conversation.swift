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
        topic: "",
        messages: []
    )
}

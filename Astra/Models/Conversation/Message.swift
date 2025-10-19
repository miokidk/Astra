//
//  Message.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

enum MessageRole: String, Codable {
    case system
    case user
    case assistant
}

struct Message: Identifiable, Codable {
    let id: MessageID
    let role: MessageRole
    let text: String
    let timestamp: Date

    init(id: MessageID = MessageID(),
         role: MessageRole,
         text: String,
         timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.timestamp = timestamp
    }
}

//
//  Board.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

struct Board: Identifiable, Codable {
    var id: BoardID
    var title: String
    var nodes: [BoardNode]
    var conversation: Conversation
    var thoughts: [Thought]
    var personality: PersonalityProfile

    static let placeholder = Board(
        id: BoardID(),
        title: "",
        nodes: [],
        conversation: Conversation.sample,
        thoughts: Thought.sampleList,
        personality: PersonalityProfile.placeholder
    )

    func removingLegacySeedContent() -> Board {
        var sanitized = self

        if sanitized.title == LegacySeedContent.boardTitle {
            sanitized.title = ""
        }

        sanitized.nodes.removeAll { LegacySeedContent.nodeTitles.contains($0.title) }

        if sanitized.conversation.topic == LegacySeedContent.conversationTopic,
           sanitized.conversation.containsLegacySeedMessages {
            sanitized.conversation.topic = ""
            sanitized.conversation.messages.removeAll()
        }

        sanitized.thoughts.removeAll { thought in
            LegacySeedContent.thoughts.contains { $0.title == thought.title && $0.detail == thought.detail }
        }

        return sanitized
    }
}

private enum LegacySeedContent {
    static let boardTitle = "Astra Alpha Board"
    static let nodeTitles: Set<String> = [
        "Project North Star",
        "User Research",
        "Sprint"
    ]
    static let conversationTopic = "Kickoff"
    static let conversationMessages: [(MessageRole, String)] = [
        (.system, "Welcome to Astra's collaborative canvas."),
        (.user, "Capture product vision and research tasks."),
        (.assistant, "Drafted starter nodes with priorities.")
    ]
    static let thoughts: [(title: String, detail: String)] = [
        (title: "Align stakeholders",
         detail: "Schedule a working session with design and research."),
        (title: "AI Assistance",
         detail: "Surface contextual prompts near relevant nodes.")
    ]
}

private extension Conversation {
    var containsLegacySeedMessages: Bool {
        guard messages.count == LegacySeedContent.conversationMessages.count else {
            return false
        }

        return zip(messages, LegacySeedContent.conversationMessages).allSatisfy { message, legacy in
            message.role == legacy.0 && message.text == legacy.1
        }
    }
}

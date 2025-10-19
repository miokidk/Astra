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
        title: "Astra Alpha Board",
        nodes: [
            BoardNode.sampleText(title: "Project North Star",
                                 body: "Define the core vision for Astra's collaborative intelligence canvas.",
                                 position: CanvasPoint(x: 120, y: 120)),
            BoardNode.sampleText(title: "User Research",
                                 body: "Interview 5 facilitators and synthesize requirements.",
                                 position: CanvasPoint(x: 320, y: 180)),
            BoardNode.sampleShape(title: "Sprint",
                                  body: "Design sprint scheduled for next Tuesday.",
                                  position: CanvasPoint(x: 220, y: 360))
        ],
        conversation: Conversation.sample,
        thoughts: Thought.sampleList,
        personality: PersonalityProfile.placeholder
    )
}

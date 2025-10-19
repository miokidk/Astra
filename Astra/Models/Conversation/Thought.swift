//
//  Thought.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

struct Thought: Identifiable, Codable {
    let id: ThoughtID
    var title: String
    var detail: String
    var relatedNodeID: NodeID?
    var createdAt: Date

    init(id: ThoughtID = ThoughtID(),
         title: String,
         detail: String,
         relatedNodeID: NodeID?,
         createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.detail = detail
        self.relatedNodeID = relatedNodeID
        self.createdAt = createdAt
    }

    static let sampleList: [Thought] = []
}

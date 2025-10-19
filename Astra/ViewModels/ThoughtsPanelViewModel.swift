//
//  ThoughtsPanelViewModel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

final class ThoughtsPanelViewModel: ObservableObject {
    @Published private(set) var thoughts: [Thought]

    private let engine: AstraEngine

    init(thoughts: [Thought] = Thought.sampleList, engine: AstraEngine) {
        self.thoughts = thoughts
        self.engine = engine
    }

    func prepend(_ thought: Thought) {
        thoughts.insert(thought, at: 0)
    }

    func regenerateSummary(from conversation: Conversation) {
        let summary = engine.summarizeConversation(conversation)
        prepend(summary)
    }
}

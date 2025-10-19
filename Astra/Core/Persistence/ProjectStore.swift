//
//  ProjectStore.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

/// Responsible for loading and persisting the active board project.
@MainActor
final class ProjectStore: ObservableObject {
    @Published private(set) var board: Board
    private let localStore: LocalJSONStore<Board>

    init(localStore: LocalJSONStore<Board>) {
        self.localStore = localStore
        let initialBoard = localStore.load() ?? Board.placeholder
        let sanitizedBoard = initialBoard.removingLegacySeedContent()
        self.board = sanitizedBoard
        localStore.save(sanitizedBoard)
    }

    func updateBoard(_ transform: (inout Board) -> Void) {
        var mutableBoard = board
        transform(&mutableBoard)
        board = mutableBoard
        localStore.save(mutableBoard)
    }
}

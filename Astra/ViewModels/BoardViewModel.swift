//
//  BoardViewModel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import CoreGraphics
import Foundation

final class BoardViewModel: ObservableObject {
    @Published private(set) var board: Board
    @Published var selectedNodeIDs: Set<NodeID> = []
    @Published var zoomScale: CGFloat = 1.0

    private let projectStore: ProjectStore
    private let logStore: LogStore
    private let scheduler: TaskScheduler
    private var cancellables = Set<AnyCancellable>()

    init(projectStore: ProjectStore, logStore: LogStore, scheduler: TaskScheduler) {
        self.projectStore = projectStore
        self.logStore = logStore
        self.scheduler = scheduler
        self.board = projectStore.board

        projectStore.$board
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.board = $0 }
            .store(in: &cancellables)
    }

    func select(node id: NodeID?) {
        guard let id else {
            selectedNodeIDs.removeAll()
            return
        }

        if selectedNodeIDs.contains(id) {
            selectedNodeIDs.remove(id)
        } else {
            selectedNodeIDs = [id]
        }
    }

    func updatePosition(for nodeID: NodeID, to point: CGPoint) {
        projectStore.updateBoard { board in
            guard let index = board.nodes.firstIndex(where: { $0.id == nodeID }) else { return }
            board.nodes[index].position = CanvasPoint(point: point)
        }
    }

    func addTextNode(from text: String, using style: NodeStyle) -> BoardNode {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let node = BoardNode(kind: .text,
                             title: trimmed.isEmpty ? "Untitled" : trimmed,
                             body: trimmed,
                             position: CanvasPoint(x: 60 + Double(board.nodes.count * 24),
                                                   y: 60 + Double(board.nodes.count * 32)),
                             style: style,
                             zIndex: .foreground)

        projectStore.updateBoard { $0.nodes.append(node) }
        logStore.append(LogEvent(level: .info,
                                 message: "Added node \"\(node.title)\"",
                                 link: LogLink(destination: .node, identifier: node.id)))
        return node
    }

    func remove(node id: NodeID) {
        projectStore.updateBoard { board in
            board.nodes.removeAll { $0.id == id }
        }
        selectedNodeIDs.remove(id)
        logStore.append(LogEvent(level: .warning,
                                 message: "Removed node",
                                 link: LogLink(destination: .node, identifier: id)))
    }
}

//
//  BoardCoordinator.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

final class BoardCoordinator {
    private let boardViewModel: BoardViewModel
    private let conversationViewModel: ConversationPanelViewModel
    private let thoughtsViewModel: ThoughtsPanelViewModel
    private let paletteViewModel: PaletteViewModel
    private let panelCoordinator: PanelCoordinator
    private let linkRouter: LinkRouter

    init(boardViewModel: BoardViewModel,
         conversationViewModel: ConversationPanelViewModel,
         thoughtsViewModel: ThoughtsPanelViewModel,
         paletteViewModel: PaletteViewModel,
         panelCoordinator: PanelCoordinator,
         linkRouter: LinkRouter) {
        self.boardViewModel = boardViewModel
        self.conversationViewModel = conversationViewModel
        self.thoughtsViewModel = thoughtsViewModel
        self.paletteViewModel = paletteViewModel
        self.panelCoordinator = panelCoordinator
        self.linkRouter = linkRouter

        linkRouter.register(destination: .node) { [weak self] link in
            guard let self, let identifier = link.identifier else { return }
            self.focus(on: identifier)
        }

        linkRouter.register(destination: .conversation) { [weak self] _ in
            self?.panelCoordinator.showConversation()
        }
    }

    func focus(on nodeID: NodeID) {
        boardViewModel.select(node: nodeID)
    }
}

extension BoardCoordinator: InputFieldViewModelDelegate {
    func inputFieldViewModel(_ viewModel: InputFieldViewModel, didSubmit text: String) {
        let node = boardViewModel.addTextNode(from: text, using: paletteViewModel.selectedStyle)
        conversationViewModel.appendMessage(role: .user, text: text)
        thoughtsViewModel.prepend(Thought(title: "New Idea",
                                          detail: text,
                                          relatedNodeID: node.id))
        panelCoordinator.showConversation()
    }
}

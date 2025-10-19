//
//  BoardView.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var viewModel: BoardViewModel

    var body: some View {
        ZoomableCanvas {
            ForEach(viewModel.board.nodes) { node in
                DraggableContainer(position: node.position.cgPoint) { newPoint in
                    viewModel.updatePosition(for: node.id, to: newPoint)
                } content: {
                    Group {
                        switch node.kind {
                        case .text:
                            TextNodeView(node: node)
                        case .image:
                            ImageNodeView(node: node)
                        case .shape:
                            ShapeNodeView(node: node)
                        }
                    }
                    .overlay {
                        if viewModel.selectedNodeIDs.contains(node.id) {
                            SelectionHandles(style: node.style)
                        }
                    }
                    .onTapGesture {
                        viewModel.select(node: node.id)
                    }
                }
            }
        }
        .onTapGesture {
            viewModel.select(node: nil)
        }
    }
}

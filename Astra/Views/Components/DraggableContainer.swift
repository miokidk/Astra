//
//  DraggableContainer.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct DraggableContainer<Content: View>: View {
    let position: CGPoint
    let onDragEnded: (CGPoint) -> Void
    let content: () -> Content

    @GestureState private var translation: CGSize = .zero

    init(position: CGPoint,
         onDragEnded: @escaping (CGPoint) -> Void,
         @ViewBuilder content: @escaping () -> Content) {
        self.position = position
        self.onDragEnded = onDragEnded
        self.content = content
    }

    var body: some View {
        content()
            .position(x: position.x + translation.width,
                      y: position.y + translation.height)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        let newPoint = CGPoint(x: position.x + value.translation.width,
                                               y: position.y + value.translation.height)
                        onDragEnded(newPoint)
                    }
            )
    }
}

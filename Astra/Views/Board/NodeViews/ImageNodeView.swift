//
//  ImageNodeView.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct ImageNodeView: View {
    let node: BoardNode

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let url = node.mediaURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            placeholder
                        @unknown default:
                            placeholder
                        }
                    }
                } else {
                    placeholder
                }
            }
            .frame(width: 220, height: 160)
            .background(node.style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: node.style.cornerRadius, style: .continuous))

            Text(node.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(12)
        }
        .shadow(color: Color.black.opacity(0.15), radius: 12, y: 8)
    }

    private var placeholder: some View {
        ZStack {
            node.style.backgroundColor
            Image(systemName: "photo")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

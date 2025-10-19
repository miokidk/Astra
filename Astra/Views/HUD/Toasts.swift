//
//  Toasts.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI

struct ToastMessage: Identifiable, Equatable {
    enum Style {
        case info
        case warning
        case error

        var tint: Color {
            switch self {
            case .info:
                return .accentColor
            case .warning:
                return .orange
            case .error:
                return .red
            }
        }
    }

    let id = UUID()
    var text: String
    var icon: String?
    var style: Style = .info

    static let info = ToastMessage(text: "Saved changes.")
}

struct Toasts: View {
    @Binding var message: ToastMessage?

    var body: some View {
        VStack {
            if let message {
                HStack(spacing: 12) {
                    if let icon = message.icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                    }
                    Text(message.text)
                        .font(.callout)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(message.style.tint.opacity(0.15), in: Capsule(style: .continuous))
                .overlay(
                    Capsule(style: .continuous)
                        .strokeBorder(message.style.tint.opacity(0.6), lineWidth: 1)
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.message = nil
                    }
                }
            }
            Spacer()
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: message?.id)
    }
}

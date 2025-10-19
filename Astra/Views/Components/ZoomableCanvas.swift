//
//  ZoomableCanvas.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

struct ZoomableCanvas<Content: View>: View {
    private let minScale: CGFloat = 0.5
    private let maxScale: CGFloat = 3.0

    @State private var scale: CGFloat = 1.0
    @GestureState private var magnification: CGFloat = 1.0

    @State private var offset: CGSize = .zero
    @State private var panTranslation: CGSize = .zero
    @State private var didPanWithSecondaryButton = false
    @State private var didPanWithoutMouseButtons = false
    @State private var isTrackpadZooming = false
    @State private var trackpadBaseScale: CGFloat = 1.0
    @State private var trackpadAccumulatedMagnification: CGFloat = 0

    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        GeometryReader { proxy in
            let effectiveScale = clamp(scale * magnification)
            let totalOffset = CGSize(width: offset.width + panTranslation.width,
                                     height: offset.height + panTranslation.height)

            ZStack {
                InfiniteDotGrid(scale: effectiveScale, offset: totalOffset)
                content()
                    .scaleEffect(effectiveScale, anchor: .center)
                    .offset(totalOffset)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(AstraColors.canvas)
            .gesture(magnificationGesture)
#if os(macOS)
            .simultaneousGesture(panGesture)
#endif
            .overlay(panCaptureOverlay)
        }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($magnification) { value, state, _ in
                state = value
            }
            .onEnded { value in
                scale = clamp(scale * value)
            }
    }

#if os(macOS)
    private var panGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let buttons = NSEvent.pressedMouseButtons
                let isSecondaryPressed = (buttons & (1 << 1)) != 0

                didPanWithSecondaryButton = isSecondaryPressed
                didPanWithoutMouseButtons = false

                if isSecondaryPressed {
                    panTranslation = value.translation
                } else {
                    panTranslation = .zero
                }
            }
            .onEnded { value in
                defer {
                    panTranslation = .zero
                    didPanWithSecondaryButton = false
                    didPanWithoutMouseButtons = false
                }

                guard didPanWithSecondaryButton else { return }
                offset.width += value.translation.width
                offset.height += value.translation.height
            }
    }
#endif

    private func beginTrackpadZoom() {
        trackpadBaseScale = scale
        isTrackpadZooming = true
        trackpadAccumulatedMagnification = 0
    }

    private func updateTrackpadZoom(delta: CGFloat) {
        guard isTrackpadZooming else { return }
        trackpadAccumulatedMagnification += delta
        let adjusted = max(0.1, 1.0 + trackpadAccumulatedMagnification)
        scale = clamp(trackpadBaseScale * adjusted)
    }

    private func endTrackpadZoom() {
        isTrackpadZooming = false
        trackpadAccumulatedMagnification = 0
    }

    private func clamp(_ value: CGFloat) -> CGFloat {
        min(max(value, minScale), maxScale)
    }

    @ViewBuilder
    private var panCaptureOverlay: some View {
#if os(iOS)
        TwoFingerPanCapture(
            onChanged: { translation in
                didPanWithoutMouseButtons = true
                panTranslation = translation
            },
            onEnded: {
                guard didPanWithoutMouseButtons else { return }
                offset.width += panTranslation.width
                offset.height += panTranslation.height
                panTranslation = .zero
                didPanWithoutMouseButtons = false
            }
        )
        .allowsHitTesting(true)
#elseif os(macOS)
        TrackpadPanCapture(
            onChanged: { translation in
                guard !didPanWithSecondaryButton else { return }
                didPanWithoutMouseButtons = true
                panTranslation = translation
            },
            onEnded: {
                guard didPanWithoutMouseButtons else { return }
                offset.width += panTranslation.width
                offset.height += panTranslation.height
                panTranslation = .zero
                didPanWithoutMouseButtons = false
            },
            onMagnifyBegan: {
                beginTrackpadZoom()
            },
            onMagnifyChanged: { delta in
                updateTrackpadZoom(delta: delta)
            },
            onMagnifyEnded: {
                endTrackpadZoom()
            }
        )
        .allowsHitTesting(true)
#else
        EmptyView()
#endif
    }
}

private struct InfiniteDotGrid: View {
    @Environment(\.colorScheme) private var colorScheme

    var scale: CGFloat
    var offset: CGSize

    private let baseSpacing: CGFloat = 88
    private let baseDotSize: CGFloat = 3.0

    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let spacing = max(baseSpacing * scale, 12)
                guard spacing > 0 else { return }

                let dotDiameter = max(baseDotSize * scale, 1.0)
                let remainderX = wrappedOffset(offset.width, spacing: spacing)
                let remainderY = wrappedOffset(offset.height, spacing: spacing)
                let originX = -spacing + remainderX
                let originY = -spacing + remainderY

                let columns = Int(size.width / spacing) + 3
                let rows = Int(size.height / spacing) + 3

                for row in 0..<rows {
                    for column in 0..<columns {
                        let x = originX + CGFloat(column) * spacing
                        let y = originY + CGFloat(row) * spacing
                        let rect = CGRect(x: x - dotDiameter / 2,
                                          y: y - dotDiameter / 2,
                                          width: dotDiameter,
                                          height: dotDiameter)
                        context.fill(Path(ellipseIn: rect), with: .color(dotColor))
                    }
                }
            }
        }
    }

    private func wrappedOffset(_ value: CGFloat, spacing: CGFloat) -> CGFloat {
        guard spacing != 0 else { return 0 }
        var remainder = value.truncatingRemainder(dividingBy: spacing)
        if remainder < 0 {
            remainder += spacing
        }
        return remainder
    }

    private var dotColor: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.16)
        default:
            return Color.black.opacity(0.12)
        }
    }
}

#if os(iOS)
private struct TwoFingerPanCapture: UIViewRepresentable {
    var onChanged: (CGSize) -> Void
    var onEnded: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onChanged: onChanged, onEnded: onEnded)
    }

    func makeUIView(context: Context) -> UIView {
        let view = PassThroughHostingView()
        view.backgroundColor = .clear

        let panGesture = UIPanGestureRecognizer(target: context.coordinator,
                                                action: #selector(Coordinator.handlePan(_:)))
        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = context.coordinator
        view.addGestureRecognizer(panGesture)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private let onChanged: (CGSize) -> Void
        private let onEnded: () -> Void

        init(onChanged: @escaping (CGSize) -> Void, onEnded: @escaping () -> Void) {
            self.onChanged = onChanged
            self.onEnded = onEnded
        }

        @objc
        func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: gesture.view)
            let size = CGSize(width: translation.x, height: translation.y)

            switch gesture.state {
            case .began, .changed:
                onChanged(size)
            case .ended, .cancelled, .failed:
                onChanged(size)
                onEnded()
                gesture.setTranslation(.zero, in: gesture.view)
            default:
                break
            }
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }

    private final class PassThroughHostingView: UIView {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            true
        }
    }
}
#elseif os(macOS)
private struct TrackpadPanCapture: NSViewRepresentable {
    var onChanged: (CGSize) -> Void
    var onEnded: () -> Void
    var onMagnifyBegan: () -> Void
    var onMagnifyChanged: (CGFloat) -> Void
    var onMagnifyEnded: () -> Void

    func makeNSView(context: Context) -> TrackingView {
        let view = TrackingView()
        view.onChanged = onChanged
        view.onEnded = onEnded
        view.onMagnifyBegan = onMagnifyBegan
        view.onMagnifyChanged = onMagnifyChanged
        view.onMagnifyEnded = onMagnifyEnded
        return view
    }

    func updateNSView(_ nsView: TrackingView, context: Context) {
        nsView.onChanged = onChanged
        nsView.onEnded = onEnded
        nsView.onMagnifyBegan = onMagnifyBegan
        nsView.onMagnifyChanged = onMagnifyChanged
        nsView.onMagnifyEnded = onMagnifyEnded
    }

    final class TrackingView: NSView {
        var onChanged: (CGSize) -> Void = { _ in }
        var onEnded: () -> Void = {}
        var onMagnifyBegan: () -> Void = {}
        var onMagnifyChanged: (CGFloat) -> Void = { _ in }
        var onMagnifyEnded: () -> Void = {}

        private var accumulated = CGSize.zero
        private var isMagnifying = false

        override var acceptsFirstResponder: Bool { true }

        override func hitTest(_ point: NSPoint) -> NSView? {
            self
        }

        override func scrollWheel(with event: NSEvent) {
            // Only consider trackpad-style events that deliver phases.
            let hasPhase = event.phase != [] || event.momentumPhase != []
            guard hasPhase else {
                super.scrollWheel(with: event)
                return
            }

            if event.phase.contains(.began) {
                accumulated = .zero
            }

            accumulated.width += event.scrollingDeltaX
            accumulated.height += event.scrollingDeltaY
            onChanged(accumulated)

            if event.phase.contains(.ended) || event.phase.contains(.cancelled) || event.momentumPhase.contains(.ended) {
                onEnded()
                accumulated = .zero
            }
        }

        override func magnify(with event: NSEvent) {
            if !isMagnifying {
                isMagnifying = true
                onMagnifyBegan()
            }

            onMagnifyChanged(event.magnification)

            if event.phase.contains(.ended) || event.phase.contains(.cancelled) || event.momentumPhase.contains(.ended) {
                onMagnifyEnded()
                isMagnifying = false
            }
        }
    }
}
#endif

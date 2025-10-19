//
//  TaskScheduler.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

/// Simple helper that exposes throttled and delayed execution for UI-level tasks.
final class TaskScheduler {
    private var throttledWorkItems: [String: DispatchWorkItem] = [:]
    private let queue = DispatchQueue(label: "ai.astra.scheduler", qos: .userInitiated)

    func perform(after delay: TimeInterval,
                 identifier: String = UUID().uuidString,
                 action: @escaping () -> Void) {
        let workItem = DispatchWorkItem(block: action)
        throttledWorkItems[identifier]?.cancel()
        throttledWorkItems[identifier] = workItem

        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}

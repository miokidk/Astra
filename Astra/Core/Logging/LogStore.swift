//
//  LogStore.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

/// Stores recent log events that drive both the log panel and developer diagnostics.
final class LogStore: ObservableObject {
    @Published private(set) var events: [LogEvent]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(events: [LogEvent] = []) {
        self.events = events
        encoder.outputFormatting = .prettyPrinted
    }

    func append(_ event: LogEvent) {
        events.append(event)
    }

    func clear() {
        events.removeAll()
    }

    func export() throws -> Data {
        try encoder.encode(events)
    }

    func importLog(data: Data) throws {
        let imported = try decoder.decode([LogEvent].self, from: data)
        events = imported
    }
}

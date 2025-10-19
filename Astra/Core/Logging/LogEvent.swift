//
//  LogEvent.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

enum LogLevel: String, Codable {
    case info
    case warning
    case error
}

struct LogEvent: Identifiable, Codable {
    let id: UUID
    let level: LogLevel
    let message: String
    let timestamp: Date
    let link: LogLink?

    init(id: UUID = UUID(),
         level: LogLevel,
         message: String,
         timestamp: Date = Date(),
         link: LogLink? = nil) {
        self.id = id
        self.level = level
        self.message = message
        self.timestamp = timestamp
        self.link = link
    }
}

//
//  LogLink.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

struct LogLink: Codable, Hashable {
    enum Destination: String, Codable {
        case node
        case conversation
        case settings
    }

    let destination: Destination
    let identifier: UUID?

    init(destination: Destination, identifier: UUID? = nil) {
        self.destination = destination
        self.identifier = identifier
    }
}

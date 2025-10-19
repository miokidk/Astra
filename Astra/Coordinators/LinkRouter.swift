//
//  LinkRouter.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

final class LinkRouter {
    private var handlers: [LogLink.Destination: [(LogLink) -> Void]] = [:]

    func register(destination: LogLink.Destination, handler: @escaping (LogLink) -> Void) {
        handlers[destination, default: []].append(handler)
    }

    func open(_ link: LogLink) {
        handlers[link.destination]?.forEach { $0(link) }
    }
}

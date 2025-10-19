//
//  DeepLinkRouter.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

final class DeepLinkRouter {
    typealias Handler = (URL) -> Void

    private var handlers: [Handler] = []

    func register(_ handler: @escaping Handler) {
        handlers.append(handler)
    }

    func handle(url: URL) {
        handlers.forEach { $0(url) }
    }
}

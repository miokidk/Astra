//
//  AstraError.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

/// Represents recoverable domain-specific failures that can be surfaced to the UI.
enum AstraError: LocalizedError {
    case persistenceFailure
    case engineUnavailable
    case invalidDeepLink(URL)
    case unsupportedOperation(String)

    var errorDescription: String? {
        switch self {
        case .persistenceFailure:
            return "We couldn't save your recent changes."
        case .engineUnavailable:
            return "The Astra engine is warming up. Try again in a moment."
        case .invalidDeepLink(let url):
            return "We couldn't understand the link: \(url.absoluteString)."
        case .unsupportedOperation(let message):
            return message
        }
    }
}

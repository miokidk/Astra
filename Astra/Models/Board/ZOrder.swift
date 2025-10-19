//
//  ZOrder.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

enum ZOrder: Int, Codable, CaseIterable {
    case background = 0
    case middle = 1
    case foreground = 2

    var next: ZOrder {
        switch self {
        case .background: return .middle
        case .middle: return .foreground
        case .foreground: return .foreground
        }
    }
}

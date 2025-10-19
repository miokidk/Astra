//
//  GeometryHelpers.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import CoreGraphics

enum GeometryHelpers {
    static func distance(between lhs: CGPoint, and rhs: CGPoint) -> CGFloat {
        let dx = lhs.x - rhs.x
        let dy = lhs.y - rhs.y
        return sqrt(dx * dx + dy * dy)
    }

    static func midpoint(of lhs: CGPoint, and rhs: CGPoint) -> CGPoint {
        CGPoint(x: (lhs.x + rhs.x) / 2, y: (lhs.y + rhs.y) / 2)
    }

    static func snap(_ point: CGPoint, toGrid size: CGFloat) -> CGPoint {
        guard size > .zero else { return point }
        let x = (point.x / size).rounded() * size
        let y = (point.y / size).rounded() * size
        return CGPoint(x: x, y: y)
    }
}

//
//  BoardNode.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import CoreGraphics
import Foundation

enum NodeKind: String, Codable {
    case text
    case image
    case shape
}

struct CanvasPoint: Codable, Equatable {
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    init(point: CGPoint) {
        self.x = point.x.doubleValue
        self.y = point.y.doubleValue
    }

    var cgPoint: CGPoint { CGPoint(x: x.cgFloatValue, y: y.cgFloatValue) }
}

private extension Double {
    var cgFloatValue: CGFloat { CGFloat(self) }
}

private extension CGFloat {
    var doubleValue: Double { Double(self) }
}

struct BoardNode: Identifiable, Codable {
    var id: NodeID
    var kind: NodeKind
    var title: String
    var body: String
    var mediaURL: URL?
    var position: CanvasPoint
    var style: NodeStyle
    var zIndex: ZOrder

    init(id: NodeID = NodeID(),
         kind: NodeKind,
         title: String,
         body: String,
         mediaURL: URL? = nil,
         position: CanvasPoint,
         style: NodeStyle,
         zIndex: ZOrder = .middle) {
        self.id = id
        self.kind = kind
        self.title = title
        self.body = body
        self.mediaURL = mediaURL
        self.position = position
        self.style = style
        self.zIndex = zIndex
    }

    static func sampleText(title: String, body: String, position: CanvasPoint) -> BoardNode {
        BoardNode(kind: .text,
                  title: title,
                  body: body,
                  position: position,
                  style: .textDefault)
    }

    static func sampleImage(title: String, url: URL, position: CanvasPoint) -> BoardNode {
        BoardNode(kind: .image,
                  title: title,
                  body: "",
                  mediaURL: url,
                  position: position,
                  style: .imageDefault)
    }

    static func sampleShape(title: String, body: String, position: CanvasPoint) -> BoardNode {
        BoardNode(kind: .shape,
                  title: title,
                  body: body,
                  position: position,
                  style: .shapeDefault)
    }
}

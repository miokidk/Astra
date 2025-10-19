//
//  ModelConfig.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

struct ModelConfig: Codable, Equatable {
    var modelName: String
    var temperature: Double
    var topP: Double
    var maxTokens: Int

    static let `default` = ModelConfig(modelName: "astra-alpha", temperature: 0.7, topP: 0.95, maxTokens: 512)
}

//
//  SettingsViewModel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var config: ModelConfig

    private let engine: AstraEngine?
    private static let supportedModels = ["gpt-5-mini", "gpt-5"]

    var availableModels: [String] { Self.supportedModels }

    init(modelConfig: ModelConfig, engine: AstraEngine? = nil) {
        var sanitizedConfig = modelConfig

        if let fallback = Self.supportedModels.first,
           !Self.supportedModels.contains(sanitizedConfig.modelName) {
            sanitizedConfig.modelName = fallback
        }

        self.config = sanitizedConfig
        self.engine = engine

        if sanitizedConfig != modelConfig {
            engine?.updateConfiguration(sanitizedConfig)
        }
    }

    func selectModel(_ name: String) {
        guard availableModels.contains(name) else { return }
        guard config.modelName != name else { return }
        config.modelName = name
        engine?.updateConfiguration(config)
    }
}

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

    init(modelConfig: ModelConfig, engine: AstraEngine? = nil) {
        self.config = modelConfig
        self.engine = engine
    }

    func updateModel(name: String) {
        config.modelName = name
        engine?.updateConfiguration(config)
    }

    func updateTemperature(_ value: Double) {
        config.temperature = value
        engine?.updateConfiguration(config)
    }
}

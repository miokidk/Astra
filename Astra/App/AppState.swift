//
//  AppState.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var toastMessage: ToastMessage?

    let projectStore: ProjectStore
    let logStore: LogStore
    let scheduler: TaskScheduler
    let engine: AstraEngine
    let modelConfig: ModelConfig
    let deepLinkRouter: DeepLinkRouter
    let linkRouter: LinkRouter

    init(projectStore: ProjectStore? = nil,
         logStore: LogStore? = nil,
         scheduler: TaskScheduler? = nil,
         modelConfig: ModelConfig? = nil,
         deepLinkRouter: DeepLinkRouter? = nil,
         linkRouter: LinkRouter? = nil) {
        let resolvedProjectStore = projectStore ?? ProjectStore(localStore: LocalJSONStore(filename: "AstraBoard"))
        let resolvedLogStore = logStore ?? LogStore()
        let resolvedScheduler = scheduler ?? TaskScheduler()
        let resolvedModelConfig = modelConfig ?? ModelConfig.default
        let resolvedDeepLinkRouter = deepLinkRouter ?? DeepLinkRouter()
        let resolvedLinkRouter = linkRouter ?? LinkRouter()

        self.projectStore = resolvedProjectStore
        self.logStore = resolvedLogStore
        self.scheduler = resolvedScheduler
        self.modelConfig = resolvedModelConfig
        self.deepLinkRouter = resolvedDeepLinkRouter
        self.linkRouter = resolvedLinkRouter
        self.engine = AstraEngine(config: resolvedModelConfig, logStore: resolvedLogStore)
    }
}

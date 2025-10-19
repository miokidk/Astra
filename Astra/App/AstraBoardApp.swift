//
//  AstraBoardApp.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation
import SwiftUI

struct AstraBoardApp: View {
    @ObservedObject var appState: AppState

    @StateObject private var boardViewModel: BoardViewModel
    @StateObject private var conversationPanelViewModel: ConversationPanelViewModel
    @StateObject private var thoughtsPanelViewModel: ThoughtsPanelViewModel
    @StateObject private var logPanelViewModel: LogPanelViewModel
    @StateObject private var inputFieldViewModel: InputFieldViewModel
    @StateObject private var paletteViewModel: PaletteViewModel
    @StateObject private var settingsViewModel: SettingsViewModel
    @StateObject private var panelCoordinator: PanelCoordinator

    private let boardCoordinator: BoardCoordinator
    @State private var isShowingSettings = false
    @State private var didRegisterRoutes = false

    init(appState: AppState) {
        self.appState = appState

        let boardVM = BoardViewModel(projectStore: appState.projectStore,
                                     logStore: appState.logStore,
                                     scheduler: appState.scheduler)
        let conversationVM = ConversationPanelViewModel(conversation: appState.projectStore.board.conversation,
                                                        engine: appState.engine)
        let thoughtsVM = ThoughtsPanelViewModel(thoughts: appState.projectStore.board.thoughts,
                                                engine: appState.engine)
        let logVM = LogPanelViewModel(logStore: appState.logStore)
        let paletteVM = PaletteViewModel()
        let settingsVM = SettingsViewModel(modelConfig: appState.modelConfig,
                                           engine: appState.engine)
        let panelCoordinator = PanelCoordinator()
        let linkRouter = appState.linkRouter
        let coordinator = BoardCoordinator(boardViewModel: boardVM,
                                           conversationViewModel: conversationVM,
                                           thoughtsViewModel: thoughtsVM,
                                           paletteViewModel: paletteVM,
                                           panelCoordinator: panelCoordinator,
                                           linkRouter: linkRouter)
        let inputVM = InputFieldViewModel(engine: appState.engine,
                                          logStore: appState.logStore)
        inputVM.delegate = coordinator

        _boardViewModel = StateObject(wrappedValue: boardVM)
        _conversationPanelViewModel = StateObject(wrappedValue: conversationVM)
        _thoughtsPanelViewModel = StateObject(wrappedValue: thoughtsVM)
        _logPanelViewModel = StateObject(wrappedValue: logVM)
        _inputFieldViewModel = StateObject(wrappedValue: inputVM)
        _paletteViewModel = StateObject(wrappedValue: paletteVM)
        _settingsViewModel = StateObject(wrappedValue: settingsVM)
        _panelCoordinator = StateObject(wrappedValue: panelCoordinator)
        boardCoordinator = coordinator

        appState.deepLinkRouter.register { url in
            guard let link = DeepLinkMapping.link(from: url) else { return }
            linkRouter.open(link)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                BoardView(viewModel: boardViewModel)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 12) {
                    TopLeftButtons(panelCoordinator: panelCoordinator)
                        .padding(.horizontal, 16)
                    Spacer()
                }
                .padding(.top, 24)

                VStack {
                    Spacer()

                    HStack {
                        FloatingInputField(viewModel: inputFieldViewModel)
                            .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 32)
                }

                panelOverlay

                Toasts(message: $appState.toastMessage)
                    .padding(.top, 40)
                    .padding(.horizontal, 24)
            }
            .navigationTitle(boardViewModel.board.title)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
        .onAppear(perform: registerRoutesIfNeeded)
        .tint(AstraColors.accent)
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Settings") {
                    isShowingSettings = true
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                PaletteView(viewModel: paletteViewModel)
            }
#else
            ToolbarItem(placement: .automatic) {
                Button("Settings") {
                    isShowingSettings = true
                }
            }
            ToolbarItem(placement: .automatic) {
                PaletteView(viewModel: paletteViewModel)
            }
#endif
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsSheet(viewModel: settingsViewModel)
#if os(iOS)
                .presentationDetents([.medium])
#endif
        }
    }

    @ViewBuilder
    private var panelOverlay: some View {
        HStack(alignment: .top, spacing: 16) {
            if panelCoordinator.isConversationVisible {
                ConversationPanel(viewModel: conversationPanelViewModel)
            }

            if panelCoordinator.isThoughtsVisible {
                ThoughtsPanel(viewModel: thoughtsPanelViewModel)
            }

            if panelCoordinator.isLogVisible {
                LogPanel(viewModel: logPanelViewModel) { link in
                    appState.linkRouter.open(link)
                }
            }
        }
        .padding(24)
    }
}

private enum DeepLinkMapping {
    static func link(from url: URL) -> LogLink? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let path = url.pathComponents.filter { $0 != "/" }

        if path.first == "node", path.count >= 2, let uuid = UUID(uuidString: path[1]) {
            return LogLink(destination: .node, identifier: uuid)
        } else if path.first == "conversation" {
            return LogLink(destination: .conversation)
        } else if path.first == "settings" {
            return LogLink(destination: .settings)
        } else if components?.host == "conversation" {
            return LogLink(destination: .conversation)
        }

        return nil
    }
}

private extension AstraBoardApp {
    func registerRoutesIfNeeded() {
        guard !didRegisterRoutes else { return }
        didRegisterRoutes = true
        appState.linkRouter.register(destination: .settings) { _ in
            DispatchQueue.main.async {
                isShowingSettings = true
            }
        }
    }
}

private struct SettingsSheet: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Model") {
                    TextField("Model name", text: Binding(
                        get: { viewModel.config.modelName },
                        set: { viewModel.updateModel(name: $0) }
                    ))
                }

                Section("Controls") {
                    HStack {
                        Text("Temperature")
                        Spacer()
                        Slider(value: Binding(
                            get: { viewModel.config.temperature },
                            set: { viewModel.updateTemperature($0) }
                        ), in: 0...1)
                    }
                }
            }
            .navigationTitle("Astra Settings")
        }
    }
}

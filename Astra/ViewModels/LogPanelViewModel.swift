//
//  LogPanelViewModel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

final class LogPanelViewModel: ObservableObject {
    @Published private(set) var events: [LogEvent] = []

    private let logStore: LogStore
    private var cancellables = Set<AnyCancellable>()

    init(logStore: LogStore) {
        self.logStore = logStore

        logStore.$events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.events = $0 }
            .store(in: &cancellables)
    }

    func clear() {
        logStore.clear()
    }
}

//
//  InputFieldViewModel.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Combine
import Foundation

protocol InputFieldViewModelDelegate: AnyObject {
    func inputFieldViewModel(_ viewModel: InputFieldViewModel, didSubmit text: String)
}

final class InputFieldViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isSubmitting: Bool = false

    weak var delegate: InputFieldViewModelDelegate?

    private let engine: AstraEngine
    private let logStore: LogStore

    init(engine: AstraEngine, logStore: LogStore) {
        self.engine = engine
        self.logStore = logStore
    }

    func submit() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isSubmitting = true
        delegate?.inputFieldViewModel(self, didSubmit: trimmed)
        engine.generateThought(for: trimmed) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSubmitting = false
                switch result {
                case .success(let thought):
                    self?.logStore.append(LogEvent(level: .info,
                                                   message: "Engine captured thought: \(thought.title)",
                                                   link: nil))
                case .failure(let error):
                    self?.logStore.append(LogEvent(level: .error,
                                                   message: error.localizedDescription,
                                                   link: nil))
                }
            }
        }
        text = ""
    }
}

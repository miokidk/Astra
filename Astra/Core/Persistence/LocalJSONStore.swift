//
//  LocalJSONStore.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

/// Lightweight JSON persistence layer backed by the app's documents directory.
struct LocalJSONStore<Value: Codable> {
    private let filename: String
    private let queue = DispatchQueue(label: "ai.astra.persistence", qos: .background)
    private let fileManager: FileManager

    init(filename: String, fileManager: FileManager = .default) {
        self.filename = filename
        self.fileManager = fileManager
    }

    func load() -> Value? {
        guard let url = fileURL(), fileManager.fileExists(atPath: url.path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Value.self, from: data)
        } catch {
            debugPrint("LocalJSONStore load error: \(error)")
            return nil
        }
    }

    func save(_ value: Value) {
        guard let url = fileURL() else { return }

        queue.async {
            do {
                let data = try JSONEncoder().encode(value)
                try data.write(to: url, options: .atomic)
            } catch {
                debugPrint("LocalJSONStore save error: \(error)")
            }
        }
    }

    private func fileURL() -> URL? {
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return directory.appendingPathComponent(filename).appendingPathExtension("json")
    }
}

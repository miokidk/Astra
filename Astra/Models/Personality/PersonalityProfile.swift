//
//  PersonalityProfile.swift
//  Astra
//
//  Created by Codex on 10/19/25.
//

import Foundation

struct PersonalityProfile: Codable, Equatable {
    var name: String
    var tone: String
    var description: String

    static let placeholder = PersonalityProfile(
        name: "Atlas",
        tone: "Curious, encouraging, pragmatic",
        description: "Atlas guides teams through complex explorations, keeping context tethered to concrete decisions."
    )
}

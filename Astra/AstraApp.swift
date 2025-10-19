//
//  AstraApp.swift
//  Astra
//
//  Created by Khalid Jackson on 10/18/25.
//

import SwiftUI

@main
struct AstraApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AstraBoardApp(appState: appState)
                .onOpenURL { url in
                    appState.deepLinkRouter.handle(url: url)
                }
        }
    }
}

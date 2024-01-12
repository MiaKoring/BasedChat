//
//  MessengerBetaApp.swift
//  MessengerBeta
//
//  Created by Mia Koring on 30.12.23.
//

import SwiftUI
import SwiftData

@main
struct MessengerBetaApp: App {

    var body: some Scene {
        WindowGroup{
            ChatView()
        }
        .modelContainer(for: [
            Chat.self,
            Message.self
        ])
    }
}

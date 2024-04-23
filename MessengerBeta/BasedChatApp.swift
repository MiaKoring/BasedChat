//
//  MessengerBetaApp.swift
//  MessengerBeta
//
//  Created by Mia Koring on 30.12.23.
//

import SwiftUI
import SwiftData
import Security

@main
struct BasedChatApp: App {
    @State public static var currentUserID: Int? = 1
    @State public static var currentToken: String? = nil
    var body: some Scene {
        WindowGroup{
            BubblePreviewProvider()
            //ChatView()
        }
        .modelContainer(for: [
            Chat.self,
            Message.self
        ])
    }
}

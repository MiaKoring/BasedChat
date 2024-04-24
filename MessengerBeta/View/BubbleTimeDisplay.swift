//
//  BubbleTimeDisplay.swift
//  MessengerBeta
//
//  Created by Mia Koring on 24.04.24.
//

import Foundation
import SwiftUI

struct BubbleTimeDisplay: View {
    let message: Message
    var body: some View {
        HStack{
            if message.sender.isCurrentUser {
                Spacer()
            }
            Text(DateHandler.formatTime(message.time, lang: "de_DE"))
                .font(.custom("JetBrainsMono-Regular", size: 10))
            if !message.sender.isCurrentUser {
                Spacer()
            }
        }
    }
}

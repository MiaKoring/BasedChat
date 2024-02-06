//
//  Chat.swift
//  MessengerBeta
//
//  Created by Mia Koring on 08.01.24.
//

import Foundation
import SwiftData

@Model class Chat: Identifiable{
    var id: UUID
    var title: String
    var participants: [String]
    var messagesID: UUID
    var pinned: Bool
    var currentMessageID: Int
    
    init(id: UUID = UUID(), title: String, participants: [String], messages : [Message] = .init(), messagesID: UUID = UUID(), pinned: Bool = false, currentMessageID: Int = 24){
        self.id = id
        self.title = title
        self.participants = participants
        self.messagesID = messagesID
        self.pinned = false
        self.currentMessageID = currentMessageID
    }
}

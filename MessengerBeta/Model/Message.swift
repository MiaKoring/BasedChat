//
//  Message.swift
//  MessengerBeta
//
//  Created by Mia Koring on 08.01.24.
//

import Foundation
import SwiftData

@Model
class Message: Identifiable, ObservableObject{
    var chatMessagesID: UUID
    var time: Int
    var sender: String
    var type: String
    var reply: Reply
    var attachments: [Attachment]
    var text: String
    var reactions: [String: String]
    var background: String
    var id: UUID = UUID()
    var messageID: Int
    
    init(chatMessagesID: UUID = UUID(), time: Int, sender: String, type: String = "normal", reply: Reply = Reply(originID: UUID(), text: "", sender: ""), attachments: [Attachment] = [], text: String, reactions: [String : String] = [:], background: String = "normal", id: UUID = UUID(), messageID: Int) {
        self.chatMessagesID = chatMessagesID
        self.time = time
        self.sender = sender
        self.type = type
        self.reply = reply
        self.attachments = attachments
        self.text = text
        self.reactions = reactions
        self.background = background
        self.id = id
        self.messageID = messageID
    }
}

@Model
class Attachment: Equatable{
    static func == (lhs: Attachment, rhs: Attachment) -> Bool {
        lhs.dataPath == rhs.dataPath
    }
    
    let type: String
    let dataPath: String
    init(type: String, dataPath: String) {
        self.type = type
        self.dataPath = dataPath
    }
}
@Model
class Reply: Equatable{
    static func == (lhs: Reply, rhs: Reply) -> Bool {
        lhs.originID == rhs.originID
    }
    
    var originID: UUID
    var text: String
    var sender: String
    
    init(originID: UUID, text: String, sender: String) {
        self.originID = originID
        self.text = text
        self.sender = sender
    }
}

struct Reaction{
    var mostUsed: String
    var countString: String
    var emojisCount: [String: Int]
    var differentEmojisCount: Int
    var peopleReactions: [String: String]
    
}

struct FormattedChar{
    let char: String
    let formats: [String]
}


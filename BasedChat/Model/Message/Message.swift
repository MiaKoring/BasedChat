import Foundation
import SwiftData

@Model
final class Message: Identifiable {
    var time: Int
    var sender: Int
    var type: MessageType.RawValue
    var reply: Reply?
    @Relationship(deleteRule: .cascade)
    var attachments = [Attachment]()
    var text: String
    var reactions: [Int: String]
    var background: String
    var id: UUID = UUID()
    var messageID: Int
    var isRead: Bool = true
    var formattedChars: [FormattedChar]
    var stickerHash: String
    var stickerName: String
    var stickerType: String
    
    init(time: Int, sender: Int, type: MessageType = .standalone, reply: Reply? = nil, text: String, reactions: [Int : String] = [:], background: String = "default", id: UUID = UUID(), messageID: Int, isRead: Bool = true, formattedChars: [FormattedChar] = [], stickerHash: String = "", stickerName: String = "", stickerType: String = "") {
        self.time = time
        self.sender = sender
        self.type = type.rawValue
        self.reply = reply
        self.text = text
        self.reactions = reactions
        self.background = background
        self.id = id
        self.messageID = messageID
        self.isRead = isRead
        self.stickerHash = stickerHash
        self.stickerName = stickerName
        self.stickerType = stickerType
        
        if formattedChars.isEmpty {
            self.formattedChars = [FormattedChar(id: 0, char: text, formats: [])]
            return
        }
        self.formattedChars = formattedChars
    }
}

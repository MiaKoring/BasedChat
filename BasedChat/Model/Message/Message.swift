import Foundation
import SwiftData
import RealmSwift

final class Message: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var time: Int
    @Persisted(originProperty: "messages") var sender: LinkingObjects<Contact>
    @Persisted(originProperty: "messages") var chat: LinkingObjects<Chat>
    @Persisted var type: MessageType.RawValue
    @Persisted var reply: Reply?
    @Persisted var attachments = RealmSwift.List<Attachment>()
    @Persisted var text: String
    @Persisted var reactions = RealmSwift.List<Reaction>()
    @Persisted var messageUUID: UUID
    @Persisted var messageID: Int
    @Persisted var isRead: Bool = true
    @Persisted var formattedSubstrings = RealmSwift.List<FormattedSubstring>()
    @Persisted var stickerHash: String
    @Persisted var stickerName: String
    @Persisted var stickerType: String
    
    var background: String = "default"
    
    override init() {
        super.init()
    }
    
    init(time: Int, type: MessageType, reply: Reply? = nil, text: String, messageUUID: UUID = UUID(), messageID: Int, isRead: Bool = true, stickerHash: String = "", stickerName: String = "", stickerType: String = "", background: String = "default") {
        self.time = time
        self.type = type.rawValue
        self.reply = reply
        self.text = text
        self.messageUUID = messageUUID
        self.messageID = messageID
        self.isRead = isRead
        self.stickerHash = stickerHash
        self.stickerName = stickerName
        self.stickerType = stickerType
        self.background = background
    }
}

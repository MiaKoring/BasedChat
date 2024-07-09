import Foundation
import RealmSwift

final class Chat: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var participants = RealmSwift.List<Contact>()
    @Persisted var messages = RealmSwift.List<Message>()
    @Persisted var pinned: Int
    @Persisted var currentMessageID: Int
    @Persisted var imagehash: String
    @Persisted var type: String
    
    override init() {
        super.init()
    }
    
    init(title: String, pinned: Int = 0, currentMessageID: Int, imagehash: String, type: ChatType) {
        self.title = title
        self.pinned = pinned
        self.currentMessageID = currentMessageID
        self.imagehash = imagehash
        self.type = type.rawValue
    }
}

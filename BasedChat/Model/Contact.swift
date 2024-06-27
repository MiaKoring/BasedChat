import SwiftData
import Foundation
import RealmSwift

final class Contact: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var userID: Int
    @Persisted var username: String
    @Persisted var publicKey: String
    @Persisted var savedAs: String
    @Persisted var chats = RealmSwift.List<Chat>()
    @Persisted var messages = RealmSwift.List<Message>()
    @Persisted var pfpHash: String
    
    override init() {
        super.init()
    }
    
    init(userID: Int, username: String, publicKey: String = "", savedAs: String = "", pfpHash: String = "") {
        self.userID = userID
        self.username = username
        self.publicKey = publicKey
        self.savedAs = savedAs
        self.pfpHash = pfpHash
    }
}

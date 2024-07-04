import Foundation
import SwiftData
import RealmSwift

final class Reply: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var originID: UUID
    @Persisted var text: String
    @Persisted var sender: Int
    
    override init() {
        super.init()
    }
    
    init(originID: UUID, text: String, sender: Int) {
        self.originID = originID
        self.text = text
        self.sender = sender
    }
}

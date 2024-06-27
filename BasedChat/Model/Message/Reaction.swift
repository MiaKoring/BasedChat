import Foundation
import RealmSwift

final class Reaction: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var reaction: String
    @Persisted var sender: Contact?
    @Persisted(originProperty: "reactions") var message: LinkingObjects<Message>
    
    override init() {
        super.init()
    }
    
    init(reaction: String, sender: Contact?) {
        self.reaction = reaction
        self.sender = sender
    }
    
}

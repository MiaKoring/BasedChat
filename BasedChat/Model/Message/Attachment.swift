import Foundation
import RealmSwift

final class Attachment: Object, ObjectKeyIdentifiable {
    @Persisted var _id: ObjectId
    @Persisted var type: String
    @Persisted var dataPath: String
    @Persisted(originProperty: "attachments") var message: LinkingObjects<Message>
    
    override init() {
        super.init()
    }
    
    init(type: String, dataPath: String) {
        self.type = type
        self.dataPath = dataPath
    }
}

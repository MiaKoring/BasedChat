import Foundation
import RealmSwift

final class FormattedSubstring: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var stringID: Int
    @Persisted var substr: String
    @Persisted var formats = RealmSwift.List<String>()
    @Persisted(originProperty: "formattedSubstrings") var message: LinkingObjects<Message>
    
    override init() {
        super.init()
    }
    
    init(id: Int, substr: String) {
        self.stringID = id
        self.substr = substr
    }
}

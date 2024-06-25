import Foundation
import RealmSwift

final class StickerCollection: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var stickers = RealmSwift.List<Sticker>()
    @Persisted var priority: CollectionPriority.RawValue
    
    override init() {
        super.init()
    }
    
    init(name: String, priority: CollectionPriority) {
        self.name = name
        self.priority = priority.rawValue
    }
    
}

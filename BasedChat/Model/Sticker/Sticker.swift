import Foundation
import RealmSwift

final class Sticker: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var type: String
    @Persisted var hashString: String
    @Persisted(originProperty: "stickers") var collections: LinkingObjects<StickerCollection>
    
    override init() {
        super.init()
    }
    
    init(name: String, type: String, hashString: String) {
        self.name = name
        self.type = type
        self.hashString = hashString
    }
}

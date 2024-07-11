import RealmSwift

extension StickerEditView {
    func deleteCollection(_ id: ObjectId?) {
        do {
            guard let id = id else { throw RealmError.idEmpty}
            try realm.write {
                guard let collection = realm.object(ofType: StickerCollection.self, forPrimaryKey: id) else { throw RealmError.objectNotFound }
                realm.delete(collection)
            }
        } catch {
            deleteFailed = true
        }
    }
}

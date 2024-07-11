import RealmSwift

extension StickerListView {
    func deleteSticker(_ sticker: Sticker?) {
        do {
            guard let sticker = sticker else { throw RealmError.idEmpty }
            try realm.write {
                guard let sticker = realm.object(ofType: Sticker.self, forPrimaryKey: sticker._id) else { throw RealmError.objectNotFound }
                for collection in sticker.collections {
                    if collection.name == "integrated" { continue }
                    guard let index = collection.stickers.firstIndex(of: sticker) else { continue }
                    collection.stickers.remove(at: index)
                }
                if !sticker.isIntegrated {
                    realm.delete(sticker)
                }
            }
        } catch {
            deleteFailed = true
        }
    }
    
    func removeSticker(_ sticker: Sticker?) {
        do {
            guard let sticker = sticker else { throw RealmError.idEmpty }
            guard let collectionID = collectionID else { throw RealmError.idEmpty }
            try realm.write {
                guard let sticker = realm.object(ofType: Sticker.self, forPrimaryKey: sticker._id) else { throw RealmError.objectNotFound }
                guard let collection = realm.object(ofType: StickerCollection.self, forPrimaryKey: collectionID) else { throw RealmError.objectNotFound }
                guard let index = collection.stickers.firstIndex(of: sticker) else { throw RealmError.objectNotFound }
                collection.stickers.remove(at: index)
            }
        } catch {
            showRemoveFailed = true
        }
    }
}

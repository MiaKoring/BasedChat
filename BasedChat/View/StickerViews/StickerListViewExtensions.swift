import RealmSwift

extension StickerListView {
    func deleteSticker(_ sticker: Sticker?) {
        do {
            guard let deleteSticker = sticker else { throw RealmError.idEmpty }
            try realm.write {
                guard let sticker = realm.object(ofType: Sticker.self, forPrimaryKey: deleteSticker._id) else { throw RealmError.objectNotFound }
                for collection in sticker.collections {
                    if collection.name == "integrated" { continue }
                    guard let index = collection.stickers.firstIndex(of: sticker) else { continue }
                    collection.stickers.remove(at: index)
                }
                if !deleteSticker.isIntegrated {
                    realm.delete(sticker)
                }
            }
        } catch {
            deleteFailed = true
        }
    }
}

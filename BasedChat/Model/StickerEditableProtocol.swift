import Foundation
import SwiftUI
import RealmSwift

protocol StickerEditable {
    func removeSticker(_ sticker: Sticker?, from: ObjectId?, showRemoveFailed: Binding<Bool>?)-> Void
}

extension StickerEditable {
    func deleteSticker(_ sticker: Sticker?, deleteFailed: Binding<Bool>?) {
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
            deleteFailed?.wrappedValue = true
        }
    }
    
    func removeSticker(_ sticker: Sticker?, from: ObjectId?, showRemoveFailed: Binding<Bool>?) {
        do {
            guard let sticker = sticker else { throw RealmError.idEmpty }
            guard let collectionID = from else { throw RealmError.idEmpty }
            try realm.write {
                guard let sticker = realm.object(ofType: Sticker.self, forPrimaryKey: sticker._id) else { throw RealmError.objectNotFound }
                guard let collection = realm.object(ofType: StickerCollection.self, forPrimaryKey: collectionID) else { throw RealmError.objectNotFound }
                guard let index = collection.stickers.firstIndex(of: sticker) else { throw RealmError.objectNotFound }
                collection.stickers.remove(at: index)
            }
        } catch {
            showRemoveFailed?.wrappedValue = true
        }
    }
}

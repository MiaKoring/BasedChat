import Foundation
import SwiftData

//MARK: - Typealias to latestVersion
typealias StickerCollection = StickerCollectionV1_1.StickerCollection

//MARK: - V1.1
enum StickerCollectionV1_1: VersionedSchema {
    static let versionIdentifier: Schema.Version = Schema.Version(1, 1, 0)
    static let models: [any PersistentModel.Type] = [StickerCollection.self, Sticker.self]
    
    @Model
    final class StickerCollection: Identifiable {
        var id: UUID
        var name: String
        var stickers: [Sticker]
        var priority: CollectionPriority.RawValue
        
        init(id: UUID = UUID(), name: String, stickers: [Sticker], priority: CollectionPriority) {
            self.id = id
            self.name = name
            self.stickers = stickers
            self.priority = priority.rawValue
        }
        
    }
}

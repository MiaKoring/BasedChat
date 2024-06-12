import Foundation
import SwiftData

@Model
final class StickerCollection: Identifiable {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade)
    var stickers: [Sticker]
    
    init(id: UUID = UUID(), name: String, stickers: [Sticker]) {
        self.id = id
        self.name = name
        self.stickers = stickers
    }
    
}

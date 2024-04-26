import Foundation
import SwiftData

@Model
final class Reply: Identifiable{
    var id: UUID
    var originID: UUID
    var text: String
    var sender: Int
    
    init(id: UUID = UUID(), originID: UUID, text: String, sender: Int) {
        self.id = id
        self.originID = originID
        self.text = text
        self.sender = sender
    }
}

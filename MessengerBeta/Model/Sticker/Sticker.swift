import Foundation
import SwiftData

@Model
final class Sticker: Identifiable {
    var id: UUID
    var name: String
    var type: String
    var hashString: String
    
    init(id: UUID = UUID(), name: String, type: String, hashString: String) {
        self.id = id
        self.name = name
        self.type = type
        self.hashString = hashString
    }
}

import Foundation
import SwiftData

@Model 
final class Chat: Identifiable {
    var id: UUID
    var title: String
    var participants: [Int]
    @Relationship(deleteRule: .cascade)
    var messages = [Message]()
    var pinned: Int?
    var currentMessageID: Int
    
    init(id: UUID = UUID(), title: String, participants: [Int] = [], messages: [Message] = [], pinned: Int? = nil, currentMessageID: Int = 0) {
        self.id = id
        self.title = title
        self.participants = participants
        self.messages = messages
        self.pinned = pinned
        self.currentMessageID = currentMessageID
    }
}

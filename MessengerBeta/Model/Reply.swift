import Foundation
import SwiftData
@Model
class Reply: Equatable{
    static func == (lhs: Reply, rhs: Reply) -> Bool {
        lhs.originID == rhs.originID
    }
    
    var originID: UUID
    var text: String
    var sender: String
    
    init(originID: UUID, text: String, sender: String) {
        self.originID = originID
        self.text = text
        self.sender = sender
    }
}

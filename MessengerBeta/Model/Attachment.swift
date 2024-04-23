import Foundation
import SwiftData
@Model
class Attachment: Equatable{
    static func == (lhs: Attachment, rhs: Attachment) -> Bool {
        lhs.dataPath == rhs.dataPath
    }
    
    let type: String
    let dataPath: String
    init(type: String, dataPath: String) {
        self.type = type
        self.dataPath = dataPath
    }
}

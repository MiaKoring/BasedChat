import Foundation
import SwiftData

@Model
final class Attachment{    
    let type: String
    let dataPath: String
    init(type: String, dataPath: String) {
        self.type = type
        self.dataPath = dataPath
    }
}

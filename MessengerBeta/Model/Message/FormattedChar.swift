import Foundation
import SwiftData

@Model
class FormattedChar {
    let id: Int
    let char: String
    let formats: [String]
    
    init(id: Int, char: String, formats: [String]) {
        self.id = id
        self.char = char
        self.formats = formats
    }
}

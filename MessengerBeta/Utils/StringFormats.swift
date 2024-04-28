import Foundation
import SwiftUI

class ItalicStringFormatter: StringFormatter {
    func isValid(_ formats: [String])-> Bool {
        formats.contains("_")
    }
    
    func addFormat(text: Text)-> Text {
        text.italic()
    }
}

class BoldStringFormatter: StringFormatter {
    func isValid(_ formats: [String])-> Bool {
        formats.contains("*")
    }
    
    func addFormat(text: Text) -> Text {
        text.bold()
    }
}

class StrikethroughStringFormatter: StringFormatter {
    func isValid(_ formats: [String])-> Bool {
        formats.contains("~")
    }
    
    func addFormat(text: Text)-> Text {
        text.strikethrough()
    }
}

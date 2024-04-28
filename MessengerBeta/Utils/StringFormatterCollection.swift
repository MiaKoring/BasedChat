import Foundation
import SwiftUI

class StringFormatterCollection: StringFormatter {
    var formatters: [StringFormatter] = []
    
    internal func addFormat(text: Text) -> Text { return text }
    
    func addFormats(formattedChar: FormattedChar)-> Text {
        var text = Text(formattedChar.char)
        
        for formatter in formatters{
            if formatter.isValid(formattedChar.formats) {
                text = formatter.addFormat(text: text)
            }
        }
        return text
    }
    
    func addFormatter(_ formatter: StringFormatter) {
        formatters.append(formatter)
    }
    
    func isValid(_ formats: [String]) -> Bool {
        for formatter in formatters {
            if !formatter.isValid(formats) { return false }
        }
        return true
    }
}

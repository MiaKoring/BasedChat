import Foundation
import SwiftUI

class ItalicStringFormatter: StringFormatter {
    func addFormat(attrStr: AttributedString) -> AttributedString {
        var str = attrStr
        for run in str.runs {
            if let currentFont = str[run.range].font {
                str[run.range].font = currentFont.italic()
            } else {
                str[run.range].font = Font.body.italic()
            }
        }
        return str
    }
    
    func isValid(_ formats: [String]) -> Bool {
        formats.contains("_")
    }
}

class BoldStringFormatter: StringFormatter {
    func addFormat(attrStr: AttributedString) -> AttributedString {
        var str = attrStr
        for run in str.runs {
            if let currentFont = str[run.range].font {
                str[run.range].font = currentFont.bold()
            } else {
                str[run.range].font = Font.body.bold()
            }
        }
        return str
    }
    
    func isValid(_ formats: [String]) -> Bool {
        formats.contains("*")
    }
}

class StrikethroughStringFormatter: StringFormatter {
    func addFormat(attrStr: AttributedString) -> AttributedString {
        var str = attrStr
        str.strikethroughStyle = .single
        return str
    }
    
    func isValid(_ formats: [String])-> Bool {
        formats.contains("~")
    }
}

import SwiftUI
import RealmSwift

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
    
    func isValid(_ formats: RealmSwift.List<String>) -> Bool {
        formats.contains("*")
    }
}

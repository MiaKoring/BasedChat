import SwiftUI
import RealmSwift

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
    
    func isValid(_ formats: RealmSwift.List<String>) -> Bool {
        formats.contains("_")
    }
}

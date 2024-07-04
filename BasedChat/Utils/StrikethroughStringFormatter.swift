import SwiftUI
import RealmSwift

class StrikethroughStringFormatter: StringFormatter {
    func addFormat(attrStr: AttributedString) -> AttributedString {
        var str = attrStr
        str.strikethroughStyle = .single
        return str
    }
    
    func isValid(_ formats: RealmSwift.List<String>)-> Bool {
        formats.contains("~")
    }
}

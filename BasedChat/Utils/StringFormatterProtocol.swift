import Foundation
import SwiftUI
import RealmSwift

protocol StringFormatter {
    func isValid(_: RealmSwift.List<String>)-> Bool
    func addFormat(attrStr: AttributedString)-> AttributedString
}


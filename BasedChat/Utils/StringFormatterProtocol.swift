import Foundation
import SwiftUI

protocol StringFormatter {
    func isValid(_: [String])-> Bool
    func addFormat(attrStr: AttributedString)-> AttributedString
}


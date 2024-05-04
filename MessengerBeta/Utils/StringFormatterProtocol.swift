import Foundation
import SwiftUI

protocol StringFormatter {
    func isValid(_: [String])-> Bool
    func addFormat(text: Text)-> Text
}


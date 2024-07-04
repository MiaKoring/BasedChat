import Foundation
import SwiftUI

protocol TextFormatter {
    var message: Message { get set }
    func formatText()-> Text
}

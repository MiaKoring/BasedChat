import Foundation
import SwiftUI

extension Binding where Value == Message {
    var isSticker: Bool {
        self.wrappedValue.isSticker
    }
}

import Foundation
import SwiftUI

protocol TimeToggler: View {
    func toggleTime(animated: Bool)
    func animatedTimeToggle()
    func timeToggle()
    func showTimeFalse()
    func showTimeTrue()
    func setTimer()
    func setAnimatedTimer()
    var keyboardShown: Bool { get set }
    var showTime: Bool { get set }
    var timer: Timer? { get set }
}

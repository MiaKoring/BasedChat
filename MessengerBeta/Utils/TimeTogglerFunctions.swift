import Foundation
import SwiftUI

extension TimeToggler {
    func toggleTime(animated: Bool = true) {
        if keyboardShown {
            hideKeyboard()
            return
        }
        if animated {
            animatedTimeToggle()
            return
        }
        timeToggle()
    }
    
    func animatedTimeToggle() {
        if showTime {
            withAnimation(.easeOut(duration: 0.1)) {
                showTimeFalse()
            }
            timer?.invalidate()
            return
        }
        
        withAnimation(.easeIn(duration: 0.1)) {
            showTimeTrue()
        }
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        setTimer()
    }
    
    func timeToggle() {
        if showTime {
            showTimeFalse()
            timer?.invalidate()
            return
        }
        
        showTimeTrue()
        
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        setTimer()
    }
}

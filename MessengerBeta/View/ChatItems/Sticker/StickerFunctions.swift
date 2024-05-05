import SwiftUI

extension Sticker {
    
    func setAnimatedTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            withAnimation(.easeOut(duration: 0.1)) {
                showTimeFalse()
            }
            timer.invalidate()
        }
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            showTimeFalse()
            timer.invalidate()
        }
    }
    
    func showTimeTrue() {
        showTime = true
    }
    
    func showTimeFalse() {
        showTime = false
    }
    
    func tapped() {
#if canImport(UIKit)
        if keyboardShown {
            hideKeyboard()
            return
        }
#endif
        if doubletapTimer.isNil || !doubletapTimer!.isValid {
            doubletapTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { dtimer in
                animatedTimeToggle()
                dtimer.invalidate()
            }
        }
        else {
            stickerSheetPresented = true
            doubletapTimer?.invalidate()
        }
    }
}

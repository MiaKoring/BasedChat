import SwiftUI

extension StickerView {
    
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
    
    func appeared(){
        if !message.reactions.isEmpty {
            reactionData = genReactions()
            reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
        }
        let stickerHash = String(message.stickerHash)
        let filteredStickers = stickers.filter({$0.hashString == stickerHash})
        
        guard filteredStickers.count > 0 else {
            return
        }
        fileExtension = filteredStickers[0].type

        name = stickerHash
    }
}

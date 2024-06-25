import SwiftUI
import SwiftData

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
            if data != nil {
                stickerSheetPresented = true
            }
            doubletapTimer?.invalidate()
        }
    }
    
    func appeared(){
        if !message.reactions.isEmpty {
            reactionData = genReactions()
            reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
        }
        hash = message.stickerHash
    }
    
    fileprivate func addToFavourites(sticker: Sticker) {
        if let collection = favourites.first {
            collection.stickers.append(sticker)
            return
        }
        
        let newFavourites = StickerCollection(name: "favourites", stickers: [sticker], priority: .high)
        context.insert(newFavourites)
    }
    
    func addToFavourites() {
        if let stickers = try? context.fetch(FetchDescriptor<Sticker>(predicate: #Predicate<Sticker> {$0.hashString == hash})), let sticker = stickers.first {
            addToFavourites(sticker: sticker)
            return
        }
        if data != nil {
            //TODO: Finish
            let newSticker = Sticker(name: message.stickerName, type: message.stickerType, hashString: message.stickerHash)
            
            addToFavourites(sticker: newSticker)
            return
            
        }
    }
}

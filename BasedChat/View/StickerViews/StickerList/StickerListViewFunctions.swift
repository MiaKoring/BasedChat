import SwiftUI
import RealmSwift

extension StickerListView {
    func plusTapped() {
        if !addStickers {
            showStickerCreator = true
            return
        }
        showAddToCollection = true
    }
    
    func calcWidth(_ readerWidth: CGFloat)-> CGFloat {
        (readerWidth - 30) / 4
    }
    
    func stickerTapped(sticker: Sticker) {
        if  !showIfAdded { //could be normal sticker view
            guard let sendStickerBinding = sendSticker else { // when else is triggered, view is either in CollectionDetailEdit or StickerEdit
                openStickerDetailEdit(sticker: sticker)
                return
            } // normal view to send a sticker
            sendStickerBinding.wrappedValue = SendableSticker(name: sticker.name, hash: sticker.hashString, type: sticker.type)
            /*guard let showParentSheetBinding = showParentSheet else { return }
            showParentSheetBinding.wrappedValue = false*/
            if closeOnTap { dismiss() }
            return
        }
        else { // View is opened from CollectionDetailView to add stickers
            do {
                try realm.write {
                    guard let collectionID = collectionID else { throw RealmError.idEmpty }
                    guard let collection = realm.object(ofType: StickerCollection.self, forPrimaryKey: collectionID) else { throw RealmError.objectNotFound }
                    guard let sticker = sticker.thaw() else { throw RealmError.thawFailed }
                    collection.stickers.append(sticker)
                }
            } catch {
                print("adding failed")
            }
        }
    }
    
    func isAdded(_ sticker: Sticker)-> Bool {
        if let collectionID, let collection = realm.object(ofType: StickerCollection.self, forPrimaryKey: collectionID), collection.stickers.contains(where: {$0._id == sticker._id}) {
            return true
        }
        return false
    }
    
    fileprivate func openStickerDetailEdit(sticker: Sticker) {
        guard let id = id else { return }
        guard let type = type else { return }
        id.wrappedValue = sticker._id
        type.wrappedValue = .sticker
        guard let detailOpen = detailOpen else { return }
        detailOpen.wrappedValue = true
    }
    
    func update(if condition: Bool) {
        if !condition { return }
        update = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            update = false
        }
    }
}

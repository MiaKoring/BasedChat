import RealmSwift

extension StickerDetailSheet {
    func addToFavourites() {
        let stickers = realm.objects(Sticker.self)
        let currentSticker = stickers.where {
            $0.hashString == message.stickerHash
        }
        if let sticker = currentSticker.first {
            $favourites.stickers.append(sticker)
            return
        }
        //TODO: Finish
        let newSticker = Sticker(name: message.stickerName, type: message.stickerType, hashString: message.stickerHash)
        
        $favourites.stickers.append(newSticker)
        return
    }
    
    func removeFromFavourites()-> Bool {
        if favourites.stickers.contains(where: {$0.hashString == message.stickerHash}) {
            guard let index = favourites.stickers.firstIndex(where: {$0.hashString == message.stickerHash}) else {
                return true
            }
            $favourites.stickers.remove(at: index)
            return true
        }
        return false
    }
}

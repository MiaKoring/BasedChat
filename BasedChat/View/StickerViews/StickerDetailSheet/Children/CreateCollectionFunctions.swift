import RealmSwift

extension CreateCollection {
    func create() {
        if nameInput.isEmpty {
            showAlert = true
            return
        }
        do {
            try realm.write {
                guard let sticker = stickers.first(where: {$0.hashString == stickerHash && $0.type == stickerType}) else {
                    let collection = realm.create(StickerCollection.self)
                    collection.name = nameInput
                    collection.priority = priority.rawValue
                    let sticker = Sticker(name: stickerName, type: stickerType, hashString: stickerHash)
                    collection.stickers.append(sticker)
                    return
                }
                let collection = realm.create(StickerCollection.self)
                collection.name = nameInput
                collection.priority = priority.rawValue
                collection.stickers.append(sticker.thaw()!)
            }
            showSheet = false
        } catch {
            showCreationError = true
        }
    }
    
    func createEmpty() {
        do {
            try realm.write {
                let collection = realm.create(StickerCollection.self)
                collection.name = nameInput
                collection.priority = priority.rawValue
            }
        } catch {
            showCreationError = true
        }
        showSheet = false
    }
}

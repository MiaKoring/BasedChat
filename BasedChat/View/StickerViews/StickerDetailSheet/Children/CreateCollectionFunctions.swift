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
                    collection.priority = priority
                    let sticker = Sticker(name: stickerName, type: stickerType, hashString: stickerHash)
                    collection.stickers.append(sticker)
                    return
                }
                let collection = realm.create(StickerCollection.self)
                collection.name = nameInput
                collection.priority = priority
                collection.stickers.append(sticker.thaw()!)
            }
            dismiss()
        } catch {
            showCreationError = true
        }
    }
    
    func createEmpty() {
        do {
            try realm.write {
                let collection = realm.create(StickerCollection.self)
                collection.name = nameInput
                collection.priority = priority
            }
        } catch {
            showCreationError = true
        }
        dismiss()
    }
}

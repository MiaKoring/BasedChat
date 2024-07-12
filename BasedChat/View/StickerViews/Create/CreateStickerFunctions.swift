import Foundation
import CryptoKit

extension CreateStickerView {
    
    func startCreation() {
        guard let imageData = checkInputs() else { return }
        let hashString = SHA256.hashString(data: imageData)
        if stickers.contains(where: {$0.hashString == hashString}) {
            stickerExists = true
            return
        }
        create()
    }
    
    func create() {
        guard let imageData = checkInputs() else {
            creationError = true
            return
        }
        let hash = SHA256.hashString(data: imageData)
        do {
            try realm.write {
                let sticker = Sticker(name: textInput, type: "jpg", hashString: hash)
                realm.add(sticker)
                try saveImage(data: imageData, hash: hash)
            }
            sticker = SendableSticker(name: textInput, hash: hash, type: "jpg")
            addToCollections = true
        } catch {
            creationError = true
        }
    }
    
    fileprivate func checkInputs()-> Data? {
        guard let imageData = imageData else {
            imageEmptyAlert = true
            return nil
        }
        if textInput.isEmpty {
            nameEmptyAlert = true
            return nil
        }
        return imageData
    }
    
    fileprivate func saveImage(data: Data, hash: String) throws {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else {
            return
        }
        
        let fileURL = documentDirectory.appendingPathComponent("\(hash).jpg")
        
        try data.write(to: fileURL)
    }
}

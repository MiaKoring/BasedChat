import SwiftUI
import RealmSwift

struct StickerSheet: View {
    @ObservedResults(Sticker.self) var stickers
    //MARK: - Body
    var body: some View {
        ForEach(stickers, id: \._id) {sticker in
            Text(sticker.name)
        }
    }
    
    //MARK: - Parameters
}

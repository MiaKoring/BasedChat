import SwiftUI
import RealmSwift

struct StickerSheet: View {
    
    //MARK: - Body
    var body: some View {
        if !update {
            StickerListView(stickers: stickers.sorted(by: {$0.name < $1.name}), update: $update, sendSticker: $sendSticker, closeOnTap: false)
        }
        else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    //MARK: - Parameters
    @ObservedResults(Sticker.self) var stickers
    @State var update: Bool = false
    @Binding var sendSticker: SendableSticker
}

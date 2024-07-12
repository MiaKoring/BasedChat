import SwiftUI
import RealmSwift

struct AddStickersToCollectionView: View {
    var body: some View {
        if !update {
            StickerListView(stickers: stickers.sorted(by: {$0.name < $1.name}), update: $update, collectionID: collectionID, showIfAdded: true)
        }
        else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    @State var update: Bool = false
    @ObservedResults(Sticker.self) var stickers
    var collectionID: ObjectId
}

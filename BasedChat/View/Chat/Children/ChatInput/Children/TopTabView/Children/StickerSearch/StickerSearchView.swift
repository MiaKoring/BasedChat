import SwiftUI

struct StickerSearch: View {
    
    //MARK: - Body
    var body: some View {
        TextField("Search", text: $searchText)
            .lineLimit(1)
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.ultraThickMaterial, style: .init(lineWidth: 1))
            }
            .padding(10)
        DynamicQueryView(searchCollectionCombined: searchText) { collections in
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(collections) { collection in
                        CollectionDisplay(collection: collection, stickerPath: $stickerPath, sendSticker: $sendSticker, showParentSheet: $showParentSheet)
                    }
                }
            }
        }
    }
    
    //MARK: - Parameters
    @State var searchText: String = ""
    @Binding var stickerPath: String
    @Binding var sendSticker: Bool
    @Binding var showParentSheet: Bool
}

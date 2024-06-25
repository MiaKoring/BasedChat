import SwiftUI

struct CollectionDisplay: View {
    
    //MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Text(collection.name)
                    .font(.title2)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(open ? 90 : 0))
                    .foregroundStyle(collection.stickers.isEmpty ? Color.gray : Color.primary)
            }
            .padding(10)
            .background() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
            }
            .onTapGesture {
                withAnimation {
                    if !collection.stickers.isEmpty {
                        open.toggle()
                    }
                }
            }
            if open {
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .top, spacing: 10) {
                        ForEach(collection.stickers, id: \.id) {sticker in
                            StickerImageView(name: sticker.hashString, fileExtension: sticker.type, data: $data, width: 100, height: 100)
                                .onTapGesture {
                                    stickerPath = sticker.hashString
                                    stickerName = sticker.name
                                    stickerType = sticker.type
                                    sendSticker.toggle()
                                    showParentSheet = false
                                }
                        }
                    }
                }
                .frame(height: collection.stickers.isEmpty ? 0 : 100)
            }
        }
        .shadow(radius: 5)
        .padding(10)
        .onAppear() {
            if collection.stickers.isEmpty {
                open = false
            }
        }
    }
    
    //MARK: - Parameters
    @State var data: Data? = nil
    @State var open: Bool = true
    let collection: StickerCollection
    @Binding var stickerPath: String
    @Binding var sendSticker: Bool
    @Binding var stickerName: String
    @Binding var stickerType: String
    @Binding var showParentSheet: Bool
}

#Preview {
    @Previewable @State var coll = StickerCollection(name: "favourites", priority: .high)
    @Previewable @State var collection = StickerCollection(name: "integrated", priority: .low)
    @Previewable @State var stickerPath = ""
    @Previewable @State var sendSticker = false
    @Previewable @State var stickerName = ""
    @Previewable @State var stickerType = ""
    @Previewable @State var showParentSheet = true
    let sticker = Sticker(name: "bababa", type: "gif", hashString: "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b")
    VStack {
        CollectionDisplay(collection: collection, stickerPath: $stickerPath, sendSticker: $sendSticker, stickerName: $stickerName, stickerType: $stickerType, showParentSheet: $showParentSheet)
            .padding(.horizontal, 30)
        CollectionDisplay(collection: collection, stickerPath: $stickerPath, sendSticker: $sendSticker, stickerName: $stickerName, stickerType: $stickerType, showParentSheet: $showParentSheet)
            .padding(.horizontal, 30)
        CollectionDisplay(collection: coll, stickerPath: $stickerPath, sendSticker: $sendSticker, stickerName: $stickerName, stickerType: $stickerType, showParentSheet: $showParentSheet)
            .padding(.horizontal, 30)
    }
    .onAppear() {
        collection.stickers.append(sticker)
    }
}

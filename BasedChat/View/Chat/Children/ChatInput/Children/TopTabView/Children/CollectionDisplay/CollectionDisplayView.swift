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
                            StickerImageView(name: sticker.hashString, fileExtension: sticker.type, width: 100, height: 100)
                                .onTapGesture {
                                    sendSticker = SendableSticker(name: sticker.name, hash: sticker.hashString, type: sticker.type)
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
    @State var open: Bool = true
    let collection: StickerCollection
    @Binding var sendSticker: SendableSticker
    @Binding var showParentSheet: Bool
}

#Preview {
    @Previewable @State var coll = StickerCollection(name: "favourites", priority: .high)
    @Previewable @State var collection = StickerCollection(name: "integrated", priority: .low)
    @Previewable @State var sendSticker = SendableSticker(name: "", hash: "", type: "")
    @Previewable @State var showParentSheet = true
    let sticker = Sticker(name: "bababa", type: "gif", hashString: "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b")
    VStack {
        CollectionDisplay(collection: collection, sendSticker: $sendSticker, showParentSheet: $showParentSheet)
            .padding(.horizontal, 30)
        CollectionDisplay(collection: collection, sendSticker: $sendSticker, showParentSheet: $showParentSheet)
            .padding(.horizontal, 30)
        CollectionDisplay(collection: coll, sendSticker: $sendSticker, showParentSheet: $showParentSheet)
            .padding(.horizontal, 30)
    }
    .onAppear() {
        collection.stickers.append(sticker)
    }
}

import SwiftUI
import RealmSwift
import SwiftChameleon

struct StickerListView: View, StickerEditable {
    
    //MARK: - Body
    
    var body: some View {
        GeometryReader { reader in
            ScrollView(.vertical){
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 10) {
                    
                    ForEach(stickers.sorted(by: {
                        $0.name < $1.name
                    }), id: \.self) { sticker in
                        StickerImageView(name: sticker.hashString, fileExtension: sticker.type, width: ((reader.size.width - 30) / 4.0), height: ((reader.size.width - 30) / 4.0))
                            .onTapGesture {
                                guard let sendStickerBinding = sendSticker else {
                                    guard let id = id else { return }
                                    guard let type = type else { return }
                                    id.wrappedValue = sticker._id
                                    type.wrappedValue = .sticker
                                    guard let detailOpen = detailOpen else { return }
                                    detailOpen.wrappedValue = true
                                    return
                                }
                                sendStickerBinding.wrappedValue = SendableSticker(name: sticker.name, hash: sticker.hashString, type: sticker.type)
                                guard let showParentSheetBinding = showParentSheet else { return }
                                showParentSheetBinding.wrappedValue = false
                            }
                            .when(deleteable, removeable) { view in
                                view
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteSticker = sticker
                                            showDeleteAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            } or: { view in
                                view
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteSticker = sticker
                                            showRemoveAlert = true
                                        } label: {
                                            Label("Remove", systemImage: "minus.square")
                                        }
                                    }
                                
                            } otherwise: { view in view }
                    }
                }
                .padding()
            }
#if canImport(UIKit)
            .onScrollPhaseChange {_,_  in
                hideKeyboard()
            }
#endif
        }
        .alert("Delete Sticker", isPresented: $showDeleteAlert) {
            Button(role: .destructive) {
                deleteSticker(deleteSticker, deleteFailed: $deleteFailed)
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Sticker will get removed from every collection, \(deleteSticker?.isIntegrated ?? false ? "except \"integrated\" " : "") are you sure?")
        }
        .alert("Failed to delete Sticker", isPresented: $deleteFailed) {
            Button {
                deleteFailed = false
            } label: {
                Text("OK")
            }
        }
        .alert("Remove from Collection", isPresented: $showRemoveAlert) {
            Button(role: .destructive) {
                removeSticker(deleteSticker, from: collectionID, showRemoveFailed: $showRemoveFailed)
            } label: {
                Text("Remove")
            }
        } message: {
            Text("Are you sure you want to remove that sticker from the selected collection? The Sticker gets removed immediately.")
        }
        .alert("Failed to remove Sticker", isPresented: $showRemoveFailed) {
            Button {
                showRemoveFailed = false
            } label: {
                Text("OK")
            }
        }
    }
    
    //MARK: - Parameters
    
    @State var stickers: [Sticker]
    @State var showDeleteAlert = false
    @State var deleteSticker: Sticker? = nil
    @State var deleteFailed: Bool = false
    @State var showRemoveAlert: Bool = false
    @State var showRemoveFailed: Bool = false
    var showParentSheet: Binding<Bool>? = nil
    var sendSticker: Binding<SendableSticker>? = nil
    var deleteable = false
    var removeable = false
    var collectionID: ObjectId? = nil
    var id: Binding<ObjectId?>? = nil
    var type: Binding<TopTabContentType>? = nil
    var detailOpen: Binding<Bool>? = nil
}

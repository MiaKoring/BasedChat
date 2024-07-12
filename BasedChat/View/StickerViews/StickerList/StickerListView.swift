import SwiftUI
import RealmSwift
import SwiftChameleon

struct StickerListView: View, StickerEditable {
    
    //MARK: - Body
    
    var body: some View {
        GeometryReader { reader in
            ScrollView(.vertical){
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 10) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.4))
                        .frame(width: ((reader.size.width - 30) / 4.0), height: ((reader.size.width - 30) / 4.0))
                        .overlay {
                            Image(systemName: "plus")
                                .font(.title)
                                .allowsHitTesting(false)
                        }
                        .onTapGesture {
                            if !addStickers {
                                showStickerCreator = true
                                return
                            }
                            showAddToCollection = true
                        }
                    ForEach(stickers.sorted(by: {
                        $0.name < $1.name
                    }), id: \.self) { sticker in
                        StickerImageView(name: sticker.hashString, fileExtension: sticker.type, width: ((reader.size.width - 30) / 4.0), height: ((reader.size.width - 30) / 4.0))
                            .onTapGesture {
                                if !addStickers && !showIfAdded{
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
                                    return
                                }
                                if showIfAdded {
                                    do {
                                        try realm.write {
                                            guard let collectionID = collectionID else { throw RealmError.idEmpty }
                                            guard let collection = realm.object(ofType: StickerCollection.self, forPrimaryKey: collectionID) else { throw RealmError.objectNotFound }
                                            guard let sticker = sticker.thaw() else { throw RealmError.thawFailed }
                                            collection.stickers.append(sticker)
                                        }
                                    } catch {
                                        print("adding failed")
                                    }
                                }
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
                            .if(showIfAdded) { view in
                                view
                                    .overlay(alignment: .topTrailing) {
                                        if let collectionID, let collection = realm.object(ofType: StickerCollection.self, forPrimaryKey: collectionID), collection.stickers.contains(where: {$0._id == sticker._id}) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .transition(.opacity)
                                        }
                                        else {
                                            Image(systemName: "circle")
                                                .transition(.opacity)
                                        }
                                            
                                    }
                            }
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
                update = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    update = false
                }
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Sticker will get removed from every collection, \(deleteSticker?.isIntegrated ?? false ? "except \"integrated\" " : "") are you sure?")
        }
        .alert("Failed to delete Sticker", isPresented: $deleteFailed) {
            AlertCloseButton(displayed: $deleteFailed)
        }
        .alert("Remove from Collection", isPresented: $showRemoveAlert) {
            Button(role: .destructive) {
                removeSticker(deleteSticker, from: collectionID, showRemoveFailed: $showRemoveFailed)
                update = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    update = false
                }
            } label: {
                Text("Remove")
            }
        } message: {
            Text("Are you sure you want to remove that sticker from the selected collection? The Sticker gets removed immediately.")
        }
        .alert("Failed to remove Sticker", isPresented: $showRemoveFailed) {
            AlertCloseButton(displayed: $showRemoveFailed)
        }
        .sheet(isPresented: $showStickerCreator) {
            CreateStickerView()
        }
        .onChange(of: showStickerCreator) {
            if !showStickerCreator {
                update = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    update = false
                }
            }
        }
        .sheet(isPresented: $showAddToCollection) {
            if let collectionID {
                AddStickersToCollectionView(collectionID: collectionID)
            }
        }
        .onChange(of: showAddToCollection) {
            if !showAddToCollection {
                update = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    update = false
                }
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
    @State var showStickerCreator: Bool = false
    @State var image: Image? = nil
    @State var showAddToCollection = false
    @Binding var update: Bool
    var showParentSheet: Binding<Bool>? = nil
    var sendSticker: Binding<SendableSticker>? = nil
    var deleteable = false
    var removeable = false
    var collectionID: ObjectId? = nil
    var id: Binding<ObjectId?>? = nil
    var type: Binding<TopTabContentType>? = nil
    var detailOpen: Binding<Bool>? = nil
    var addStickers: Bool = false
    var showIfAdded: Bool = false
}

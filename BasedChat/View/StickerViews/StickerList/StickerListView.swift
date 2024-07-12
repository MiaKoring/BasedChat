import SwiftUI
import RealmSwift
import SwiftChameleon

struct StickerListView: View, StickerEditable {
    
    //MARK: - Body
    
    var body: some View {
        GeometryReader { reader in
            ScrollView(.vertical){
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 10) {
                    PlusButton(width: ((reader.size.width - 30) / 4.0))
                        .onTapGesture {
                            plusTapped()
                        }
                    ForEach(stickers.sorted(by: {
                        $0.name < $1.name
                    }), id: \.self) { sticker in
                        StickerImageView(name: sticker.hashString, fileExtension: sticker.type, width: calcWidth(reader.size.width), height: calcWidth(reader.size.width))
                            .onTapGesture {
                                stickerTapped(sticker: sticker)
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
                                        if isAdded(sticker) {
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
        .sheet(isPresented: $showStickerCreator) {
            CreateStickerView()
        }
        .sheet(isPresented: $showAddToCollection) {
            if let collectionID {
                AddStickersToCollectionView(collectionID: collectionID)
            }
            else {
                ContentUnavailableView("Something went wrong", systemImage: "exclamationmark.triangle")
            }
        }
        .alert("Delete Sticker", isPresented: $showDeleteAlert) {
            Button(role: .destructive) {
                deleteSticker(deleteSticker, deleteFailed: $deleteFailed)
                update(if: true)
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
                update(if: true)
            } label: {
                Text("Remove")
            }
        } message: {
            Text("Are you sure you want to remove that sticker from the selected collection? The Sticker gets removed immediately.")
        }
        .alert("Failed to remove Sticker", isPresented: $showRemoveFailed) {
            AlertCloseButton(displayed: $showRemoveFailed)
        }
        .onChange(of: showStickerCreator) { update(if: !showStickerCreator) }
        .onChange(of: showAddToCollection) { update(if: !showAddToCollection) }
    }
    
    //MARK: - Parameters
    
    //Default Value gets changed in the cases mentioned in comments
    
    //always used
    @State var stickers: [Sticker]
    @Binding var update: Bool
    @Environment(\.dismiss) var dismiss
    
    //Alerts and sheets
    @State var showDeleteAlert = false
    @State var deleteSticker: Sticker? = nil
    @State var deleteFailed: Bool = false
    @State var showRemoveAlert: Bool = false
    @State var showRemoveFailed: Bool = false
    @State var showStickerCreator: Bool = false
    @State var showAddToCollection = false
    
    //when sticker should be sent
    var sendSticker: Binding<SendableSticker>? = nil
    
    //StickerEdit
    var deleteable = false
    var id: Binding<ObjectId?>? = nil //to open DetailEdit
    var detailOpen: Binding<Bool>? = nil //to open DetailEdit
    var type: Binding<TopTabContentType>? = nil //to open the correct editor
    
    //CollectionDetailEdit
    var removeable = false
    var collectionID: ObjectId? = nil
    
    //add stickers from CollectionDetailEdit
    var showIfAdded: Bool = false
    var addStickers: Bool = false
    
    //small-sticker-send sheet
    var closeOnTap: Bool = true
}

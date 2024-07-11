import SwiftUI
import RealmSwift
import SwiftChameleon

struct StickerListView: View {
    
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
                                guard let sendStickerBinding = sendSticker else { return }
                                sendStickerBinding.wrappedValue = SendableSticker(name: sticker.name, hash: sticker.hashString, type: sticker.type)
                                guard let showParentSheetBinding = showParentSheet else { return }
                                showParentSheetBinding.wrappedValue = false
                            }
                            .if(editable) { view in
                                view
                                    .contextMenu(){
                                        Button(role: .destructive) {
                                            deleteSticker = sticker
                                            showDeleteAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
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
                deleteSticker(deleteSticker)
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
    }
    
    //MARK: - Parameters
    
    @State var stickers: [Sticker]
    @State var showDeleteAlert = false
    @State var deleteSticker: Sticker? = nil
    @State var deleteFailed: Bool = false
    var showParentSheet: Binding<Bool>? = nil
    var sendSticker: Binding<SendableSticker>? = nil
    var editable = false
}

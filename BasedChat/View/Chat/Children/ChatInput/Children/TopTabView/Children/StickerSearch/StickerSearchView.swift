import SwiftUI
import RealmSwift

struct StickerSearch: View {
    
    //MARK: - Body
    var body: some View {
        TextField("Search", text: $searchText)
            .lineLimit(1)
            .autocorrectionDisabled()
        #if os(iOS)
            .textInputAutocapitalization(.never)
        #endif
            .padding(10)
            .overlay {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, style: .init(lineWidth: 1))
                    HStack(spacing: 10) {
                        Spacer()
                        if selected == .collection {
                            Button {
                                filterEmptyCollections.toggle() 
                            } label: {
                                Image(systemName: filterEmptyCollections ? "line.3.horizontal.decrease.circle.fill": "line.3.horizontal.decrease.circle")
                                    .font(.system(size: 20))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .font(.system(size: 20))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.trailing, 10)
                }
            }
        HStack {
            TopTabButton(selected: $selected, id: .sticker, image: .custom("sticker.bold"), imageFont: .system(size: 18))
            Divider()
            TopTabButton(selected: $selected, id: .collection, image: .system("tray.2"), imageFont: .system(size: 18))
        }
        .frame(height: 31)
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 7)
                .fill(.ultraThickMaterial)
                .shadow(radius: 6)
        }
        switch selected {
            case .sticker:
                DynamicQueryView(searchStickerName: searchText) { stickers in
                    GeometryReader { reader in
                        ScrollView(.vertical){
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 10) {
                                
                                ForEach(stickers.sorted(by: {
                                    $0.name < $1.name
                                }), id: \.self) { sticker in
                                    StickerImageView(name: sticker.hashString, fileExtension: sticker.type, data: $data, width: ((reader.size.width - 30) / 4.0), height: ((reader.size.width - 30) / 4.0))
                                        .onTapGesture {
                                            stickerPath = sticker.hashString
                                            stickerName = sticker.name
                                            stickerType = sticker.type
                                            sendSticker.toggle()
                                            showParentSheet = false
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
                }
                .frame(minHeight: 500)
            case .collection:
                DynamicQueryView(searchCollectionName: searchText, filterEmpty: filterEmptyCollections) { collections in
                    ScrollView(.vertical) {
                        LazyVStack {
                            ForEach(collections.sorted(by: {
                                $0.priority > $1.priority
                            })) { collection in
                                CollectionDisplay(collection: collection, stickerPath: $stickerPath, sendSticker: $sendSticker, stickerName: $stickerName, stickerType: $stickerType, showParentSheet: $showParentSheet)
                            }
                        }
                    }
#if canImport(UIKit)
                    .onScrollPhaseChange {_,_  in
                        hideKeyboard()
                    }
#endif
                }
                .frame(minHeight: 500)
            default:
                Text("How did we get here") // should be impossible
        }
    }
    
    func getUniqueStickers(_ stickers: [Sticker])-> [Sticker] {
        var unique: [Sticker] = []
        var used: [String] = []
        for sticker in stickers {
            if !used.contains(sticker.hashString) {
                unique.append(sticker)
                used.append(sticker.hashString)
            }
        }
        return unique
    }
    
    //MARK: - Parameters
    @State var searchText: String = ""
    @State var selected: TopTabContentType = .sticker
    @Binding var showParentSheet: Bool
    @Binding var stickerPath: String
    @Binding var sendSticker: Bool
    @Binding var stickerName: String
    @Binding var stickerType: String
    @State var data: Data? = nil
    @State var filterEmptyCollections: Bool = false
}

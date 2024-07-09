import SwiftUI
import RealmSwift

struct StickerSearch: View {
    
    //MARK: - Body
    var body: some View {
        VStack {
            SearchBar(label: "Search", searchText: $searchText)
                .overlay {
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
                        if stickers.isEmpty {
                            ContentUnavailableView("No Results for \"\(searchText)\"", systemImage: "magnifyingglass", description: Text("Try checking the pronounciation or start a new search"))
                        }
                        else {
                            GeometryReader { reader in
                                ScrollView(.vertical){
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 10) {
                                        
                                        ForEach(stickers.sorted(by: {
                                            $0.name < $1.name
                                        }), id: \.self) { sticker in
                                            StickerImageView(name: sticker.hashString, fileExtension: sticker.type, data: $data, width: ((reader.size.width - 30) / 4.0), height: ((reader.size.width - 30) / 4.0))
                                                .onTapGesture {
                                                    sendSticker = SendableSticker(name: sticker.name, hash: sticker.hashString, type: sticker.type)
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
                    }
                case .collection:
                    DynamicQueryView(searchCollectionName: searchText, filterEmpty: filterEmptyCollections) { collections in
                        if collections.isEmpty {
                            ContentUnavailableView("No Results for \"\(searchText)\"", systemImage: "magnifyingglass", description: Text("Try checking the pronounciation or start a new search"))
                        }
                        else {
                            ScrollView(.vertical) {
                                LazyVStack {
                                    ForEach(collections.sorted(by: {
                                        $0.priority > $1.priority
                                    })) { collection in
                                        CollectionDisplay(collection: collection, sendSticker: $sendSticker, showParentSheet: $showParentSheet)
                                    }
                                }
                            }
#if canImport(UIKit)
                            .onScrollPhaseChange {_,_  in
                                hideKeyboard()
                            }
#endif
                        }
                    }
                default:
                    Text("How did we get here") // should be impossible
            }
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
    @Binding var sendSticker: SendableSticker
    @State var data: Data? = nil
    @State var filterEmptyCollections: Bool = false
}

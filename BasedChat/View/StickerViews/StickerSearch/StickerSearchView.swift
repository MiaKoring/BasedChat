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
            .topTabBarStyle()
            switch selected {
                case .sticker:
                    DynamicQueryView(searchStickerName: searchText) { stickers in
                        if stickers.isEmpty {
                            ContentUnavailableView("No Results for \"\(searchText)\"", systemImage: "magnifyingglass", description: Text("Try checking the pronounciation or start a new search"))
                        }
                        else {
                            StickerListView(stickers: stickers, update: $update, sendSticker: $sendSticker)
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
    
    //MARK: - Parameters
    @State var searchText: String = ""
    @State var selected: TopTabContentType = .sticker
    @Binding var showParentSheet: Bool
    @Binding var sendSticker: SendableSticker
    @State var filterEmptyCollections: Bool = false
    @State var update: Bool = false

    
    
}

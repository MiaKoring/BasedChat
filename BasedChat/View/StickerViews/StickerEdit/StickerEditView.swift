import SwiftUI
import RealmSwift
import SwiftChameleon

struct StickerEditView: View {
    
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
                .padding(.top, 20)
                .padding(.horizontal, 20)
            HStack {
                TopTabButton(selected: $selected, id: .sticker, image: .custom("sticker.bold"), imageFont: .system(size: 18))
                Divider()
                TopTabButton(selected: $selected, id: .collection, image: .system("tray.2"), imageFont: .system(size: 18))
            }
            .topTabBarStyle()
            if !update {
                switch selected {
                    case .sticker:
                        DynamicQueryView(searchStickerName: searchText) { stickers in
                            if stickers.isEmpty {
                                ContentUnavailableView("No Results for \"\(searchText)\"", systemImage: "magnifyingglass", description: Text("Try checking the pronounciation or start a new search"))
                            }
                            else {
                                StickerListView(stickers: stickers, update: $update, deleteable: true, id: $detailID, detailOpen: $showDetail, type: $detailType)
                            }
                        }
                        .padding(.horizontal, 20)
                    case .collection:
                        DynamicQueryView(searchCollectionName: searchText, filterEmpty: filterEmptyCollections, excludeIntegrated: true) { collections in
                            if collections.isEmpty {
                                ContentUnavailableView("No Results for \"\(searchText)\"", systemImage: "magnifyingglass", description: Text("Try checking the pronounciation or start a new search"))
                            }
                            else {
                                List {
                                    Button {
                                        showCollectionCreation = true
                                    } label: {
                                        Label("Create", systemImage: "plus")
                                    }
                                    ForEach(collections) { collection in
                                        CollectionRow(collection: collection, showIfAdded: false, detailID: $detailID, detailType: $detailType, showDetail: $showDetail)
                                            .if(collection.name != "integrated" && collection.name != "favourites"){ view in
                                                view
                                                    .swipeActions {
                                                        Button(role: .destructive) {
                                                            deleteID = collection._id
                                                            showDeleteAlert = true
                                                        } label: {
                                                            Image(systemName: "trash")
                                                        }
                                                    }
                                            }
                                    }
                                }
                                .listStyle(PlainListStyle())
#if canImport(UIKit)
                                .onScrollPhaseChange {_,_  in
                                    hideKeyboard()
                                }
#endif
                            }
                        }
                    default:
                        Text("how did we get here") // shouldn't be possible
                }
            }
            Spacer()
        }
        .alert("Delete Collection?", isPresented: $showDeleteAlert) {
            Button(role: .destructive) {
                deleteCollection(deleteID)
            } label: {
                Text("Delete")
            }
        } message: {
            Text("Are you sure you want to delete this collection? You will keep the stickers.")
        }
        .alert("Delete Failed", isPresented: $deleteFailed) {
            AlertCloseButton(displayed: $deleteFailed)
        }
        .sheet(isPresented: $showDetail) {
            DetailEditView(id: $detailID, type: $detailType)
        }
        .sheet(isPresented: $showCollectionCreation) {
            CreateCollection(disableCreationChoice: true)
        }
        .onChange(of: showDetail) {
            if !showDetail { triggerUpdate() }
        }
        .onChange(of: showCollectionCreation) {
            if !showCollectionCreation { triggerUpdate() }
        }
    }
    
    //MARK: - Parameters
    @State var selected: TopTabContentType = .sticker
    @State var filterEmptyCollections: Bool = false
    @State var searchText: String = ""
    @State var showDeleteAlert: Bool = false
    @State var deleteID: ObjectId? = nil
    @State var deleteFailed: Bool = false
    @State var showDetail: Bool = false
    @State var detailType: TopTabContentType = .sticker
    @State var detailID: ObjectId? = nil
    @State var showCollectionCreation: Bool = false
    @State var update: Bool = false
    
    func triggerUpdate() {
        update = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            update = false
        }
    }
}

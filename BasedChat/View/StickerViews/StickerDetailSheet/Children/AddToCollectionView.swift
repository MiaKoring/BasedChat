import SwiftUI
import RealmSwift

struct AddToCollectionView: View {
    
    //MARK: - Body
    var body: some View {
        VStack {
            HStack {
                SearchBar(label: "Search", searchText: $searchText)
                    .overlay {
                        HStack {
                            Spacer()
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
                Button {
                    showCreateCollection = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                }
                #if os(macOS)
                .buttonStyle(PlainButtonStyle())
                #endif
            }
            .padding(.bottom, 10)
            if collections.isEmpty {
                VStack {
                    Spacer()
                    ContentUnavailableView("You don't have any collections yet", systemImage: "magnifyingglass")
                    Button {
                        showCreateCollection = true
                    } label: {
                        Text("Create Collection")
                    }
                    .buttonStyle(BorderedButtonStyle())
                    Spacer()
                }
            }
            else if searchText.isEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(collections) { collection in
                            CollectionRow(collection: collection, stickerHash: stickerHash, stickerType: stickerType, stickerName: stickerName)
                            if collection != collections.last {
                                Divider()
                                    .padding(.leading, 80)
                            }
                        }
                    }
                }
            }
            else {
                if !update {
                    DynamicQueryView(searchCollectionName: searchText) { collections in
                        if collections.isEmpty {
                            ContentUnavailableView("No Results for \"\(searchText)\"", systemImage: "magnifyingglass", description: Text("Try checking the pronounciation or start a new search"))
                        }
                        else {
                            ScrollView {
                                LazyVStack(alignment: .leading, spacing: 10) {
                                    ForEach(collections) { collection in
                                        CollectionRow(collection: collection, stickerHash: stickerHash, stickerType: stickerType, stickerName: stickerName)
                                        if collection != collections.last {
                                            Divider()
                                                .padding(.leading, 80)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    ProgressView()
                        .progressViewStyle(.circular
                        )
                }
            }
        }
        .padding(20)
        .sheet(isPresented: $showCreateCollection) {
            CreateCollection(stickerHash: stickerHash, stickerType: stickerType, stickerName: stickerName)
        }
        .onChange(of: showCreateCollection) {
            if !showCreateCollection {
                print("triggered")
                update = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    update = false
                }
            }
        }
    }
    
    //MARK: - Parameters
    @ObservedResults(StickerCollection.self, where: { $0.name != "favourites" && $0.name != "integrated"}) var collections
    @State var searchText: String = ""
    @State var showCreateCollection: Bool = false
    @State var update: Bool = false
    let stickerHash: String
    let stickerType: String
    let stickerName: String
}

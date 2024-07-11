import SwiftUI
import RealmSwift

struct StickerDetailEditView: View, StickerEditable {
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Name")) {
                    TextField("", text: $sticker.name)
                        .disabled(true)
                }
                Section(header: Text("Image")) {
                    StickerImageView(name: sticker.hashString, fileExtension: sticker.type)
                }
                Section(header: Text("Type")) {
                    TextField("", text: $sticker.type)
                        .disabled(true)
                }
                //TODO: Add other filetypes
                if sticker.type == "gif" {
                    Button {
                        showExporter.toggle()
                    } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                    .fileExporter(isPresented: $showExporter, document: Doc(url: Bundle.main.path(forResource: sticker.hashString, ofType: sticker.type)!), contentType: .gif) { (res) in
                        do {
                            let fileUrl = try res.get()
                            print(fileUrl)
                        } catch {
                            print("couldn't save")
                            print(error.localizedDescription)
                        }
                    }
                }
                else {
                    if let path = Bundle.main.path(forResource: sticker.hashString, ofType: sticker.type), let url = URL(string: path), let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                        ShareLink(item: Photo(image: Image(uiImage: uiImage)), preview: SharePreview(sticker.name))
                    }
                    else {
                        Text("Sharing unavailable")
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 400)
            Divider()
            
            HStack {
                Text("Collections")
                    .font(.title2)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isOpen ? 90 : 0))
            }
            .padding(10)
            .background() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
            }
            .padding(.horizontal, 20)
            .onTapGesture {
                withAnimation {
                    isOpen.toggle()
                }
            }
            if isOpen {
                if sticker.collections.isEmpty {
                    ContentUnavailableView("Sticker is not yet added to any collection", systemImage: "xmark.rectangle")
                }
                else {
                    List {
                        ForEach(sticker.collections) { collection in
                            if collection.name != "integrated" {
                                CollectionRow(collection: collection, showIfAdded: false, detailID: $id, detailType: $type)
                                    .swipeActions() {
                                        Button(role: .destructive) {
                                            from = collection._id
                                            showRemoveAlert = true
                                        } label: {
                                            Image(systemName: "minus.square")
                                        }
                                    }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .transition(.scale)
                }
            }
            Spacer()
        }
        .padding(.top, 20)
        .alert("Remove from Collection", isPresented: $showRemoveAlert) {
            Button(role: .destructive) {
                removeSticker(sticker, from: from, showRemoveFailed: $showRemoveFailed)
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
    
    @ObservedRealmObject var sticker: Sticker
    @State var isOpen: Bool = false
    @Binding var id: ObjectId?
    @Binding var type: TopTabContentType
    @State var showExporter: Bool = false
    @State var showRemoveAlert = false
    @State var showRemoveFailed = false
    @State var from: ObjectId? = nil
}

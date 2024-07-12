import SwiftUI
import RealmSwift

struct CollectionRow: View {
    
    var body: some View {
        HStack {
            HStack {
                if collection.stickers.count > 0, let imageHash = collection.stickers.first?.hashString, let type = collection.stickers.first?.type {
                    StickerImageView(isDone: true, name: imageHash, fileExtension: type, width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray)
                        .frame(width: 60, height: 60)
                }
            }
            .padding(.horizontal, 10)
            VStack(alignment: .leading) {
                Text(collection.name)
                if showIfAdded && stickerAdded() {
                    Text("already added")
                        .font(.footnote)
                }
            }
            Spacer()
        }
        .background {
            if highlighted {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
            }
        }
        .onTapGesture(perform: tapped)
        .alert("Failed adding Sticker", isPresented: $addingFailedAlert) {
            AlertCloseButton(displayed: $addingFailedAlert)
        } message: {
            Text("Please try again")
        }
    }
    
    //MARK: - Parameters
    
    @ObservedRealmObject var collection: StickerCollection
    @ObservedResults(Sticker.self) var stickers
    @State var stickerHash: String = ""
    @State var stickerType: String = ""
    @State var stickerName: String = ""
    @State var showIfAdded = true
    @State var data: Data? = nil
    @State var highlighted: Bool = false
    @State var addingFailedAlert: Bool = false
    var detailID: Binding<ObjectId?>? = nil
    var detailType: Binding<TopTabContentType>? = nil
    var showDetail: Binding<Bool>? = nil
    
    //MARK: - Functions
    
    func stickerAdded() -> Bool {
        collection.stickers.contains(where: {$0.hashString == stickerHash && $0.type == stickerType})
    }
  
    func tapped() {
        withAnimation {
            highlighted = true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                withAnimation {
                    highlighted = false
                }
            }
        }
        if !showIfAdded {
            detailID?.wrappedValue = collection._id
            detailType?.wrappedValue = .collection
            showDetail?.wrappedValue = true
            return
        }
        if stickerAdded() { return }
        do {
            try realm.write {
                guard let sticker = stickers.first(where: {$0.hashString == stickerHash && $0.type == stickerType}) else {
                    let sticker = Sticker(name: stickerName, type: stickerType, hashString: stickerHash)
                    guard let thawed = collection.thaw() else { throw RealmError.thawFailed }
                    thawed.stickers.append(sticker)
                    return
                }
                guard let thawed = collection.thaw() else { throw RealmError.thawFailed }
                guard let thawedSticker = sticker.thaw() else { throw RealmError.thawFailed }
                thawed.stickers.append(thawedSticker)
            }
        } catch {
            addingFailedAlert = true
        }
    }
}

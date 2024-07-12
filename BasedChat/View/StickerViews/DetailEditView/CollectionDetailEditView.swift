import SwiftUI
import RealmSwift

struct CollectionDetailEditView: View {
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            Form {
                CollectionCreationFormComponents(nameInput: $collection.name, priority: $collection.priority)
            }
            .frame(height: 200)
            .disabled(collection.name == "favourites")
            .padding(.top, 20)
            HStack {
                Text("Stickers")
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
                if !update {
                    VStack{
                        if collection.stickers.isEmpty {
                            ContentUnavailableView("Collection is empty", systemImage: "xmark.rectangle")
                        }
                        else {
                            StickerListView(stickers: collection.stickers.sorted(by: {$0.name < $1.name}), update: $update, id: $id, type: $type, removeable: true, collectionID: collection._id, addStickers: true)
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .transition(.scale)
                }
                else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            Spacer()
        }
    }
    
    //MARK: - Parameters
    
    @ObservedRealmObject var collection: StickerCollection
    @Environment(\.dismiss) var dismiss
    @State var nameInput: String
    @State var priority: CollectionPriority
    @Binding var id: ObjectId?
    @Binding var type: TopTabContentType
    @State var isOpen: Bool = false
    @State var update: Bool = false
}

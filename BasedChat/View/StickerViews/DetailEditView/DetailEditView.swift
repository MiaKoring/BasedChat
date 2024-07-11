import SwiftUI
import RealmSwift

struct DetailEditView: View {
    
    //MARK: - Body
    var body: some View {
        switch type {
            case .sticker:
                VStack {
                    if let sticker = getSticker() {
                        StickerDetailEditView(sticker: sticker, id: $id, type: $type)
                    }
                    else {
                        ContentUnavailableView("Couldn't find sticker", systemImage: "exclamationmark.triangle")
                    }
                }
            case .collection:
                if let collection = getCollection() {
                    CollectionDetailEditView(collection: collection, nameInput: collection.name, priority: CollectionPriority(rawValue: collection.priority) ?? .regular, id: $id, type: $type)
                }
                else {
                    ContentUnavailableView("Couldn't find collection", systemImage: "exclamationmark.triangle")
                }
            default:
                Text("How did we get here") //shouldn't be possible
        }
    }
    
    //MARK: - Parameters
    
    @Binding var id: ObjectId?
    @Binding var type: TopTabContentType
    
    //MARK: - Functions
    
    func getSticker()-> Sticker? {
        guard let id = id else { return nil }
        return realm.object(ofType: Sticker.self, forPrimaryKey: id)
    }
    
    func getCollection()-> StickerCollection? {
        guard let id = id else { return nil }
        return realm.object(ofType: StickerCollection.self, forPrimaryKey: id)
    }
    
}

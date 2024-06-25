import SwiftUI
import SwiftData

public struct DynamicQueryView<T: PersistentModel, Content: View>: View {
    @Query var query: [T]
    
    let content: ( [T] ) -> Content
    
    public var body: some View {
        self.content(query)
    }
    
    init( descriptor: FetchDescriptor<T>,  @ViewBuilder content: @escaping ( [T] ) -> Content) {
        _query = Query( descriptor )
        self.content = content
    }
    
}

extension DynamicQueryView where T : StickerCollection {
    init( searchCollectionName: String, filterEmpty: Bool, @ViewBuilder content: @escaping ([T]) -> Content) {
        let sort = [SortDescriptor<T>(\T.priority, order: .reverse), SortDescriptor<T>(\T.name, order: .forward)]
        if !filterEmpty {
            let filter = #Predicate<T> {
                $0.name.contains(searchCollectionName) || searchCollectionName.isEmpty }
            self.init( descriptor: FetchDescriptor( predicate: filter, sortBy: sort), content: content )
            return
        }
        let filter = #Predicate<T> {
            ($0.name.contains(searchCollectionName) || searchCollectionName.isEmpty) && !$0.stickers.isEmpty }
        self.init( descriptor: FetchDescriptor( predicate: filter, sortBy: sort), content: content )
    }
    
    init( searchCollectionCombined: String, @ViewBuilder content: @escaping ([T]) -> Content) {
        let filter = #Predicate<T> {
            $0.name.contains(searchCollectionCombined) ||
            searchCollectionCombined.isEmpty ||
            $0.stickers.contains(where: {sticker in
                sticker.name.contains(searchCollectionCombined)
            })  }
        self.init( descriptor: FetchDescriptor( predicate: filter), content: content )
    }
}

extension DynamicQueryView where T : Sticker {
    init( searchStickerName: String, @ViewBuilder content: @escaping ([T]) -> Content) {
        let filter = #Predicate<T> {
            $0.name.contains(searchStickerName) || searchStickerName.isEmpty }
        self.init( descriptor: FetchDescriptor( predicate: filter), content: content )
    }
}

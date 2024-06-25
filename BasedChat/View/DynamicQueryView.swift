import SwiftUI
import Foundation
import RealmSwift

public struct DynamicQueryView<T: Object & Identifiable, Content: View>: View {
    @ObservedResults(T.self) var results: Results<T>
    
    let content: ([T]) -> Content
    
    public var body: some View {
        self.content(Array(results))
    }
    
    public init(query: ((Query<T>) -> Query<Bool>)? = nil, @ViewBuilder content: @escaping ([T]) -> Content) {
        if let filter = query {
            _results = ObservedResults(T.self, where: filter)
        } else {
            _results = ObservedResults(T.self)
        }
        self.content = content
    }
}

extension DynamicQueryView where T : StickerCollection {
    init( searchCollectionName: String, filterEmpty: Bool, @ViewBuilder content: @escaping ([T]) -> Content) {
        /*let sort = [
            RealmSwift.SortDescriptor(keyPath: "priority", ascending: false),
            RealmSwift.SortDescriptor(keyPath: "name", ascending: true),
        ]*/
        
        if !filterEmpty {
            let filter: ((Query<T>)->Query<Bool>)? = searchCollectionName.isEmpty ? nil : {
                $0.name.contains(searchCollectionName)
            }
            self.init(query: filter, content: content)
            return
        }
        
        let filter: ((Query<T>)->Query<Bool>)? = searchCollectionName.isEmpty ? {
            $0.stickers.count > 0
        } : {
            $0.name.contains(searchCollectionName) &&
            $0.stickers.count > 0
        }
        self.init(query: filter, content: content)
    }
}

extension DynamicQueryView where T : Sticker {
    init( searchStickerName: String, @ViewBuilder content: @escaping ([T]) -> Content) {
        if !searchStickerName.isEmpty {
            let filter: (Query<T>)->Query<Bool> = {
                $0.name.contains(searchStickerName)
            }
            self.init(query: filter, content: content)
            return
        }
        self.init(content: content)
        return
    }
}

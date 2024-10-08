import SwiftUI
import Foundation
import RealmSwift

public struct DynamicQueryView<T: Object & Identifiable, Content: View>: View {
    @ObservedResults(T.self) var results: Results<T>
    
    let content: ([T]) -> Content
    
    public var body: some View {
        self.content(Array(results))
    }
    
    public init(query: ((Query<T>) -> Query<Bool>)? = nil, sortDescriptor: RealmSwift.SortDescriptor? = nil, @ViewBuilder content: @escaping ([T]) -> Content) {
        if let filter = query {
            _results = ObservedResults(T.self, where: filter, sortDescriptor: sortDescriptor)
        } else {
            _results = ObservedResults(T.self, sortDescriptor: sortDescriptor)
        }
        self.content = content
    }
}

extension DynamicQueryView where T : StickerCollection {
    init( searchCollectionName: String, filterEmpty: Bool, excludeIntegrated: Bool = false, @ViewBuilder content: @escaping ([T]) -> Content) {
        let sort = RealmSwift.SortDescriptor(keyPath: "priority", ascending: false)
        
        if !filterEmpty {
            if excludeIntegrated {
                let filter: ((Query<T>)->Query<Bool>) = searchCollectionName.isEmpty ? {$0.name != "integrated"} : {
                    $0.name.contains(searchCollectionName) && $0.name != "integrated"
                }
                self.init(query: filter, sortDescriptor: sort, content: content)
                return
            }
            
            let filter: ((Query<T>)->Query<Bool>)? = searchCollectionName.isEmpty ? nil : {
                $0.name.contains(searchCollectionName)
            }
            self.init(query: filter, sortDescriptor: sort, content: content)
            return
        }
        
        if excludeIntegrated {
            let filter: ((Query<T>)->Query<Bool>) = searchCollectionName.isEmpty ? {
                $0.stickers.count > 0 && $0.name != "integrated"
            } : {
                $0.name.contains(searchCollectionName) &&
                $0.stickers.count > 0 &&
                $0.name != "integrated"
            }
            self.init(query: filter, sortDescriptor: sort, content: content)
            return
        }
        let filter: ((Query<T>)->Query<Bool>)? = searchCollectionName.isEmpty ? {
            $0.stickers.count > 0
        } : {
            $0.name.contains(searchCollectionName) &&
            $0.stickers.count > 0
        }
        self.init(query: filter, sortDescriptor: sort, content: content)
    }
    
    init( searchCollectionName: String, excludingSystem: Bool = true, @ViewBuilder content: @escaping ([T]) -> Content ) {
        let sort = RealmSwift.SortDescriptor(keyPath: "name", ascending: true)
        
        if !excludingSystem {
            let filter: ((Query<T>)->Query<Bool>)? = searchCollectionName.isEmpty ? nil : {
                $0.name.contains(searchCollectionName)
            }
            self.init(query: filter, sortDescriptor: sort, content: content)
            return
        }
        
        let filter: ((Query<T>)->Query<Bool>)? = searchCollectionName.isEmpty ? {
            $0.name != "favourites" && $0.name != "integrated"
        } : {
            $0.name.contains(searchCollectionName) &&
            $0.name != "favourites" && $0.name != "integrated"
        }
        self.init(query: filter, sortDescriptor: sort, content: content)
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

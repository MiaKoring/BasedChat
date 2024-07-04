import SwiftUI
import Foundation
import RealmSwift

extension MessageView {
    
    func appeared() {
        rendered = messages[max(0, messages.count - 50)...(messages.count - 1)].reversed()
        currentID = rendered.last?._id
    }
    
    func loadMore() {
        guard let firstIndex = messages.firstIndex(where: {
            $0._id == currentID
        }) else {
            appeared()
            return
        }
        let startIndex = messages.index(before: firstIndex)
        let appendBy = messages[max(0, startIndex - 50)...min(startIndex, messages.count - 1)].reversed()
        rendered.append(contentsOf: appendBy)
        currentID = rendered.last?._id
    }
    
    func add(message: Message) {
        withAnimation {
            rendered.insert(message, at: 0)
        }
    }
    
    func update(message: Message) {
        guard let renIndex = rendered.firstIndex(where: {$0._id == message._id}) else { return }
        rendered[renIndex] = message
    }
}

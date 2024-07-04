import Foundation
import RealmSwift

struct BuiltReactions: Equatable {
    var mostUsed: String
    var countString: String
    var emojisCount: [String: Int]
    var differentEmojisCount: Int
    var peopleReactions: RealmSwift.List<Reaction>
    
    init(mostUsed: String, countString: String, emojisCount: [String : Int], differentEmojisCount: Int, peopleReactions: RealmSwift.List<Reaction>) {
        self.mostUsed = mostUsed
        self.countString = countString
        self.emojisCount = emojisCount
        self.differentEmojisCount = differentEmojisCount
        self.peopleReactions = peopleReactions
    }
}

import Foundation

public struct Reaction: Equatable{
    public var mostUsed: String
    public var countString: String
    public var emojisCount: [String: Int]
    public var differentEmojisCount: Int
    public var peopleReactions: [Int: String]
    public init(mostUsed: String, countString: String, emojisCount: [String : Int], differentEmojisCount: Int, peopleReactions: [Int : String]) {
        self.mostUsed = mostUsed
        self.countString = countString
        self.emojisCount = emojisCount
        self.differentEmojisCount = differentEmojisCount
        self.peopleReactions = peopleReactions
    }
}

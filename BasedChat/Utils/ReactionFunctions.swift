import Foundation
import SwiftUI

extension ReactionInfluenced {
    func genReactions()-> BuiltReactions {
        let (differentEmojis, counts) = extractDifferentEmojis()
        var totalCount = 0.0
        var reactionCache = ""
        
        for i in 0 ..< counts.count {
            guard let countForEmoji = counts[differentEmojis[i]] else { continue }
            totalCount += Double(countForEmoji)
        }
        
        let sortedByCount = Dictionary(uniqueKeysWithValues: counts.sorted(by: {$0.value > $1.value}))
        let reactionList = Array(sortedByCount.keys)
        
        for i in 0 ..< sortedByCount.count {
            if (i < 4) {
                reactionCache += reactionList[i]
            }
        }
        
        totalCount = counts.count.double
        
        var countString = String(Int(totalCount))
        
        if totalCount > 1000 {
            totalCount = totalCount / 1000
            totalCount = (totalCount*10).rounded()/10
            countString = String(totalCount)+"K"
        }
        
        return BuiltReactions(mostUsed: reactionCache, countString: countString, emojisCount: counts, differentEmojisCount: differentEmojis.count, peopleReactions: message.reactions)
    }
    
    fileprivate func extractDifferentEmojis()-> (Array<String>, [String: Int]) {
        var emojis: [String] = []
        var counts: [String: Int] = [:]
        for reaction in message.reactions {
            let emoji = reaction.reaction
            
            if !emojis.contains(emoji) {
                emojis.append(emoji)
                counts[emoji] = 1
                continue
            }
            
            counts[reaction.reaction]? += 1
        }
        return (emojis, counts)
    }
}

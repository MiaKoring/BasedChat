import Foundation
import SwiftUI

extension ReactionInfluenced {
    /*func formatText()-> some View {
        var text = Text("")
        for i in 0..<formattedChars.count {
            if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic().strikethrough()
            }
            else if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && !formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic()
            }
            else if formattedChars[i].formats.contains("*") && !formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).strikethrough()
            }
            else if formattedChars[i].formats == ["*"] {
                text = text+Text(formattedChars[i].char).fontWeight(.bold)
            }
            else if !formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).italic().strikethrough()
            }
            else if formattedChars[i].formats == ["_"] {
                text = text+Text(formattedChars[i].char).italic()
            }
            else if formattedChars[i].formats == ["~"] {
                text = text+Text(formattedChars[i].char).strikethrough()
            }
            else {
                text = text + Text(formattedChars[i].char)
            }
        }
        return text
    }
    */
    
    func formatText()-> some View{
        let collection = StringFormatterCollection()
        collection.addFormatter(BoldStringFormatter())
        collection.addFormatter(ItalicStringFormatter())
        collection.addFormatter(StrikethroughStringFormatter())
        
        var text = AttributedString()
        
        for i in 0..<formattedChars.count{
            text = text + collection.addFormats(formattedChar: formattedChars[i])
        }
        return Text(text)
    }
    
    func genReactions()-> Reaction {
        let differentEmojis = Array(Set(message.reactions.values))
        var emojisCount: [String : Int] = [:]
        var totalCount = 0.0
        var reactionCache = ""
        let differentEmojisCount = differentEmojis.count
        
        for i in 0 ..< differentEmojis.count {
            let countForEmoji = message.reactions.keys(forValue: differentEmojis[i]).count
            emojisCount[differentEmojis[i]] = countForEmoji
            totalCount += Double(countForEmoji)
        }
        
        let sortedByCount = Dictionary(uniqueKeysWithValues: emojisCount.sorted(by: {$0.value > $1.value}))
        let reactionList = Array(sortedByCount.keys)
        
        for i in 0 ..< sortedByCount.count {
            if (i < 4) {
                reactionCache += reactionList[i]
            }
        }
        
        var countString = String(Int(totalCount))
        
        if totalCount > 1000 {
            totalCount = totalCount / 1000
            totalCount = (totalCount*10).rounded()/10
            countString = String(totalCount)+"K"
        }
        
        return Reaction(mostUsed: reactionCache, countString: countString, emojisCount: emojisCount, differentEmojisCount: differentEmojisCount, peopleReactions: message.reactions)
    }
}

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
        
        var text = Text("")
        
        for i in 0..<formattedChars.count{
            text = text + collection.addFormats(formattedChar: formattedChars[i])
        }
        return text
    }
    
    func formatChars(_ str: String) -> [FormattedChar] {
        let italicRegex: NSRegularExpression? = {
            do {
                return try NSRegularExpression(pattern: "(?<![^ ~\\*])_\\S(?:(?!\\S_ ).)*\\S_(?![^ ~\\*])")
            }
            catch { return nil }
        }()
        let boldRegex: NSRegularExpression? = {
            do {
                return try NSRegularExpression(pattern: "(?<![^ _~])\\*\\S(?:(?!\\S\\* ).)*\\S\\*(?![^ _~])")
            }
            catch { return nil }
        }()
        let strikethroughRegex: NSRegularExpression? = {
            do {
                return try NSRegularExpression(pattern: "(?<![^ _\\*])~\\S(?:(?!\\S~ ).)*\\S~(?![^ _\\*])")
            }
            catch { return nil }
        }()
        
        var results: [FormattedChar] = []
        let italicRanges = italicRegex!.matches(in: str, range: NSRange(str.startIndex..., in: str))
        let boldRanges = boldRegex!.matches(in: str, range: NSRange(str.startIndex..., in: str))
        let strikethroughRanges = strikethroughRegex!.matches(in: str, range: NSRange(str.startIndex..., in: str))
        
        var currentSubstr = ""
        var currentFormats: [String] = []
        
        for i in 0..<str.count {
            let index = str.index(str.startIndex, offsetBy: i)
            let current = "\(str[index])"
            if italicRanges.contains(where: {$0.range.lowerBound == i}) || boldRanges.contains(where: {$0.range.lowerBound == i}) || strikethroughRanges.contains(where: {$0.range.lowerBound == i}) {
                results.append(FormattedChar(char: currentSubstr, formats: currentFormats))
                
                currentSubstr = ""
                currentFormats.append(current)
                continue
            }
            else if italicRanges.contains(where: {$0.range.upperBound - 1 == i}) || boldRanges.contains(where: {$0.range.upperBound - 1 == i}) || strikethroughRanges.contains(where: {$0.range.upperBound - 1 == i}) {
                results.append(FormattedChar(char: currentSubstr, formats: currentFormats))
                
                currentSubstr = ""
                currentFormats.removeAll(where: {$0 == current})
                continue
            }
            currentSubstr.append(current)
            if i == str.count - 1 {
                results.append(FormattedChar(char: currentSubstr, formats: currentFormats))
            }
        }
        return results
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

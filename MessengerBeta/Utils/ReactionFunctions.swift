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
        var formattedChars: [FormattedChar] = []
        var currentChar = ""
        var previousChar = ""
        var currentFormats: [String] = []
        var blockAdding = false
        let input = str.replacingOccurrences(of: "\n", with: "￿")
        let allowedSurroundingChars = ["", " ", "￿", ".", ",", ":", ";", "\"", "'", "*", "_", "~"]
        
        for i in 0..<input.count {
            let atm =  String(input[input.index(input.startIndex, offsetBy: i)])
            let next = i + 1 < input.count ? String(input[input.index(input.startIndex, offsetBy: i+1)]) : ""
            
            if (atm == "*" || atm == "_" || atm == "~") && (allowedSurroundingChars.contains(previousChar) || allowedSurroundingChars.contains(next)) {
                    
                if !currentChar.isEmpty {
                    let formattedChar = FormattedChar(char: currentChar, formats: currentFormats)
                    formattedChars.append(formattedChar)
                    currentChar = ""
                    
                }
                if currentFormats.contains(String(atm)) && allowedSurroundingChars.contains(next){
                    currentFormats.removeAll(where: {$0 == String(atm)})
                    blockAdding = true
                }
                if !blockAdding && allowedSurroundingChars.contains(previousChar) {
                    currentFormats.append(String(atm))
                }
                else{
                    blockAdding = false
                }
            } 
            else {
                currentChar.append(atm)
            }
            previousChar = atm
            
        }
        if !currentChar.isEmpty {
            let formattedChar = FormattedChar(char: currentChar.replacingOccurrences(of: "￿", with: "\n"), formats: currentFormats)
            formattedChars.append(formattedChar)
        }
        
        return formattedChars
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

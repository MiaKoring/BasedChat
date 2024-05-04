import Foundation
import SwiftData

@Model
final class Message: Identifiable {
    var time: Int
    var sender: Int
    var type: String
    var reply: Reply?
    @Relationship(deleteRule: .cascade)
    var attachments = [Attachment]()
    var text: String
    var reactions: [Int: String]
    var background: String
    var id: UUID = UUID()
    var messageID: Int
    var isRead: Bool = true
    //var formattedChars: [FormattedChar]
    
    init(time: Int, sender: Int, type: String = "standalone", reply: Reply? = nil, text: String, reactions: [Int : String] = [:], background: String = "default", id: UUID = UUID(), messageID: Int, isRead: Bool = true/*, formattedChars: [FormattedChar]*/) {
        self.time = time
        self.sender = sender
        self.type = type
        self.reply = reply
        self.text = text
        self.reactions = reactions
        self.background = background
        self.id = id
        self.messageID = messageID
        self.isRead = isRead
        //self.formattedChars = formatChars(text)
    }
}

extension Message {
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
}

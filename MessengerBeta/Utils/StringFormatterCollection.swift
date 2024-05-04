import Foundation
import SwiftUI

class StringFormatterCollection: StringFormatter {
    var formatters: [StringFormatter] = []
    
    internal func addFormat(text: Text) -> Text { return text }
    
    func addFormats(formattedChar: FormattedChar)-> Text {
        var text = Text(formattedChar.char)
        
        for formatter in formatters{
            if formatter.isValid(formattedChar.formats) {
                text = formatter.addFormat(text: text)
            }
        }
        return text
    }
    
    func addFormatter(_ formatter: StringFormatter) {
        formatters.append(formatter)
    }
    
    func isValid(_ formats: [String]) -> Bool {
        for formatter in formatters {
            if !formatter.isValid(formats) { return false }
        }
        return true
    }
    
    public static func formatChars(_ str: String) -> [FormattedChar] {
        if !str.contains("_") && !str.contains("~") && !str.contains("*") {
            return [FormattedChar(id: 0, char: str, formats: [])]
        }
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
                results.append(FormattedChar(id: (results.last?.id ?? -1) + 1, char: currentSubstr, formats: currentFormats))
                
                currentSubstr = ""
                currentFormats.append(current)
                continue
            }
            else if italicRanges.contains(where: {$0.range.upperBound - 1 == i}) || boldRanges.contains(where: {$0.range.upperBound - 1 == i}) || strikethroughRanges.contains(where: {$0.range.upperBound - 1 == i}) {
                results.append(FormattedChar(id: (results.last?.id ?? -1) + 1, char: currentSubstr, formats: currentFormats))
                
                currentSubstr = ""
                currentFormats.removeAll(where: {$0 == current})
                continue
            }
            currentSubstr.append(current)
            if i == str.count - 1 {
                results.append(FormattedChar(id: (results.last?.id ?? -1) + 1, char: currentSubstr, formats: currentFormats))
            }
        }
        return results
    }
}

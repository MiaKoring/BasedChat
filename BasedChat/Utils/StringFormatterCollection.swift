import Foundation
import SwiftUI
import RealmSwift

class StringFormatterCollection: StringFormatter {
    var formatters: [StringFormatter] = []
    
    internal func addFormat(attrStr: AttributedString) -> AttributedString { return attrStr }
    
    func addFormats(formattedSubstring: FormattedSubstring)-> AttributedString {
        var attrStr = AttributedString(formattedSubstring.substr)
        
        for formatter in formatters{
            if formatter.isValid(formattedSubstring.formats) {
                attrStr = formatter.addFormat(attrStr: attrStr)
            }
        }
        return attrStr
    }
    
    func addFormatter(_ formatter: StringFormatter) {
        formatters.append(formatter)
    }
    
    func isValid(_ formats: RealmSwift.List<String>) -> Bool {
        for formatter in formatters {
            if !formatter.isValid(formats) { return false }
        }
        return true
    }
    
    public static func formatSubstrs(_ str: String) -> [FormattedSubstring] {
        if !str.contains("_") && !str.contains("~") && !str.contains("*") {
            return [FormattedSubstring(id: 0, substr: str)]
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
        
        var results: [FormattedSubstring] = []
        let italicRanges = italicRegex!.matches(in: str, range: NSRange(str.startIndex..., in: str))
        let boldRanges = boldRegex!.matches(in: str, range: NSRange(str.startIndex..., in: str))
        let strikethroughRanges = strikethroughRegex!.matches(in: str, range: NSRange(str.startIndex..., in: str))
        
        var currentSubstr = ""
        var currentFormats: [String] = []
        
        for i in 0..<str.count {
            let index = str.index(str.startIndex, offsetBy: i)
            let current = "\(str[index])"
            if italicRanges.contains(where: {$0.range.lowerBound == i}) || boldRanges.contains(where: {$0.range.lowerBound == i}) || strikethroughRanges.contains(where: {$0.range.lowerBound == i}) {
    
                let substr = FormattedSubstring(id: Int(results.last?.id ?? 0) + 1, substr: currentSubstr)
                for format in currentFormats {
                    substr.formats.append(format)
                }
                results.append(substr)
                
                currentSubstr = ""
                currentFormats.append(current)
                continue
            }
            else if italicRanges.contains(where: {$0.range.upperBound - 1 == i}) || boldRanges.contains(where: {$0.range.upperBound - 1 == i}) || strikethroughRanges.contains(where: {$0.range.upperBound - 1 == i}) {
                
                let substr = FormattedSubstring(id: Int((results.last?.id ?? 0)) + 1, substr: currentSubstr)
                for format in currentFormats {
                    substr.formats.append(format)
                }
                results.append(substr)
                
                currentSubstr = ""
                currentFormats.removeAll(where: {$0 == current})
                continue
            }
            currentSubstr.append(current)
            if i == str.count - 1 {
                let substr = FormattedSubstring(id: Int((results.last?.id ?? 0)) + 1, substr: currentSubstr)
                for format in currentFormats {
                    substr.formats.append(format)
                }
                results.append(substr)
            }
        }
        return results
    }
}

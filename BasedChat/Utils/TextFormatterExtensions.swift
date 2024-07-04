import SwiftUI

extension TextFormatter {
    func formatText()-> Text{
        let collection = StringFormatterCollection()
        collection.addFormatter(BoldStringFormatter())
        collection.addFormatter(ItalicStringFormatter())
        collection.addFormatter(StrikethroughStringFormatter())
        
        var text = AttributedString()
        
        let substrings = message.formattedSubstrings.sorted(by: {
            $0.stringID < $1.stringID
        })
        
        for i in 0..<substrings.count{
            text = text + collection.addFormats(formattedSubstring: message.formattedSubstrings[i])
        }
        return Text(text)
    }
}

import Foundation
import SwiftUI

struct ReplyView: View {
    //MARK: - Body
    var body: some View {
        if !message.type.range(of: "reply", options: .caseInsensitive).isNil && message.reply != nil {
            HStack {
                ZStack(alignment: .leading) {
                    MatchWidthView(text: message.text, width: message.type.contains("sticker") ? 200 : nil)
                    AnswerDisplayView(text: message.reply!.text, sender: message.reply!.sender, originMessageID: message.reply!.originID)
                }
            }
            .messageExtrasBackground()
            .onTapGesture {
                scrollTo = message.reply!.originID
                triggerScroll.toggle()
                glowOriginMessage = message.reply!.originID
            }
        }
    }
    
    //MARK: - Parameters
    
    let message: Message
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll: Bool
    @Binding var glowOriginMessage: UUID?
    
    //MARK: -
}

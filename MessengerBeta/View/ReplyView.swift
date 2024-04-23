import Foundation
import SwiftUI

struct ReplyView: View {
    let message: Message
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll: Bool
    @Binding var glowOriginMessage: UUID?
    var body: some View {
        if message.type == "reply" && !message.reply.isDeleted{
            HStack{
                ZStack(alignment: .leading){
                    MatchWidthView(text: message.text)
                    AnswerDisplay(text: message.reply.text, senderName: message.reply.sender, originMessageID: message.reply.originID)
                }
            }
            .messageExtrasBackground()
            .onTapGesture {
                scrollTo = message.reply.originID
                triggerScroll.toggle()
                glowOriginMessage = message.reply.originID
            }
        }
    }
}

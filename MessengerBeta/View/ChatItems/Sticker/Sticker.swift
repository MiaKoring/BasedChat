import Foundation
import SwiftUI
import SwiftChameleon

struct Sticker: View {
    var body: some View {
        HStack {
            if message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
            VStack{
                if !name.isNil {
                    ReplyView(message: message, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage)
                    StickerImageView(name: name!, fileExtension: fileExtension)
                }
            }
            .padding(6)
            .bubbleBackground(isCurrent: message.sender.isCurrentUser, background: message.background, show: !message.type.range(of: "reply", options: .caseInsensitive).isNil)
            if !message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
        }
        .onAppear(){
            if message.stickerPath.hasPrefix("integrated") {
                let stickerName = String(message.stickerPath.trimmingPrefix("integrated"))
                fileExtension = IntegratedStickers.stickers[stickerName] ?? "jpg"
                name = stickerName
            }
            //TODO: Add user created Stickers
        }
    }
    
    @State var name: String? = nil
    @State var fileExtension: String = "jpg"
    @Binding var message: Message
    @Binding var triggerScroll: Bool
    @Binding var glowOriginMessage: UUID?
    @Binding var scrollTo: UUID?
    let minSpacerWidth: Double
}
//let uuid = UUID()

//Message(time: Date().intTimeIntervalSince1970, sender: 1, type: .sticker, text: "", messageID: 1000, isRead: false, formattedChars: [FormattedChar(id: 0, char: "", formats: [])], stickerPath: "integratedTalkingCat")

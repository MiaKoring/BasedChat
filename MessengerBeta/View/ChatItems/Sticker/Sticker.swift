import Foundation
import SwiftUI
import SwiftChameleon

struct Sticker: View, TimeToggler, ReactionInfluenced {
    var body: some View {
        VStack{
            HStack {
                if message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
                VStack{
                    if !name.isNil {
                        ReplyView(message: message, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage)
                        StickerImageView(name: name!, fileExtension: fileExtension)
                    }
                }
                .overlay(alignment: message.sender.isCurrentUser ? .bottomLeading : .bottomTrailing){
                    ReactionDisplayView(reactionContainer: reactionContainer, textCount: 10, reactionData: reactionData, sender: message.sender, opaque: true, bottomCardReaction: $bottomCardReaction, bottomCardOpen: $bottomCardOpen)
                        .padding(message.sender.isCurrentUser ? .leading : .trailing, 20)
                        .offset(.init(width: 0.0, height: 17.0))
                }
                .padding(message.type.range(of: "reply", options: .caseInsensitive).isNil ? 10 : 6)
                .bubbleBackground(isCurrent: message.sender.isCurrentUser, background: message.background, show: !message.type.range(of: "reply", options: .caseInsensitive).isNil)
                .onTapGesture {
                    tapped()
                }
                .contextMenu() {
                    BubbleContextMenu(message: message, replyTo: $replyTo, deleteAlertPresented: $deleteAlertPresented)
                }
                if !message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
            }
            if showTime{ BubbleTimeDisplayView(message: message) }
        }
        .sheet(isPresented: $stickerSheetPresented, content: {
            //TODO: Bigger Sticker Display, add/remove from favourites
            Text("Sheet hallo")
                .presentationDetents([.medium])
                .presentationBackground(.ultraThickMaterial)
        })
        .onAppear(){
            if message.stickerPath.hasPrefix("integrated") {
                let stickerName = String(message.stickerPath.trimmingPrefix("integrated"))
                fileExtension = IntegratedStickers.stickers[stickerName] ?? "jpg"
                name = stickerName
            }
            //TODO: Add user created Stickers
            if !message.reactions.isEmpty {
                reactionData = genReactions()
                reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
            }
        }
        .alert(LocalizedStringKey("DeleteAlert"), isPresented: $deleteAlertPresented) {
            Button(role: .destructive) {
                messageToDelete = message
            } label: {
                Text(LocalizedStringKey("Delete"))
            }
        }
    }
    
    @State var name: String? = nil
    @State var fileExtension: String = "jpg"
    @Binding var message: Message
    @Binding var triggerScroll: Bool
    @Binding var glowOriginMessage: UUID?
    @Binding var scrollTo: UUID?
    @Binding var showTime: Bool
    @Binding var keyboardShown: Bool
    @Binding var timer: Timer?
    @Binding var replyTo: Reply?
    @State var reactionContainer = ""
    @State var doubletapTimer: Timer? = nil
    @State var stickerSheetPresented = false
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction?
    @Binding var messageToDelete: Message?
    let minSpacerWidth: Double
    @State var deleteAlertPresented = false
    
    
    var formattedChars: [FormattedChar] =  [] //conformance
}
//let uuid = UUID()

//Message(time: Date().intTimeIntervalSince1970, sender: 1, type: .sticker, text: "", messageID: 1000, isRead: false, formattedChars: [FormattedChar(id: 0, char: "", formats: [])], stickerPath: "integratedTalkingCat")

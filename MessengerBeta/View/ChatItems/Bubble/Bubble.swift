import Foundation
import SwiftUI
import SwiftData

struct Bubble: View, ReactionInfluenced, TimeToggler {
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                if message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading) {
                        LinkView(URLs: URLs, messageText: message.text)
                        ReplyView(message: message, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage)
                        MessageTextView(message: message, reactionContainer: $reactionContainer, formattedChars: $formattedChars)
                        
                    }
                    .padding(message.type.range(of: "reply", options: .caseInsensitive).isNil ? 10 : 6)
                    
                    ReactionDisplayView(reactionContainer: reactionContainer, textCount: message.text.count, reactionData: reactionData, sender: message.sender, opaque: false, bottomCardReaction: $bottomCardReaction, showStickerDetail: $showStickerDetail)
                        .hidden()
                }
                .bubbleBackground(isCurrent: message.sender.isCurrentUser, background: message.background)
                .overlay(alignment: message.sender.isCurrentUser ? .bottomLeading : .bottomTrailing) {
                    ReactionDisplayView(reactionContainer: reactionContainer, textCount: message.text.count, reactionData: reactionData, sender: message.sender, opaque: false, bottomCardReaction: $bottomCardReaction, showStickerDetail: $showStickerDetail)
                }
                .contextMenu() {
                    BubbleContextMenu(message: message, replyTo: $replyTo, deleteAlertPresented: $deleteAlertPresented)
                }
                //TODO: add custom popover
                if !message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
            }
            .background(.clear)
            .onTapGesture {
                #if canImport(UIKit)
                if !keyboardShown {
                    toggleTime()
                    return
                }
                hideKeyboard()
                #else
                toggleTime()
                #endif
            }
            .onAppear() {
                if !message.reactions.isEmpty {
                    reactionData = genReactions()
                    reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
                }
                URLs = extractURLs(from: message.text)
            }
            if showTime{ BubbleTimeDisplayView(message: message) }
        }
        .alert(LocalizedStringKey("DeleteAlert"), isPresented: $deleteAlertPresented) {
            Button(role: .destructive) {
                messageToDelete = message
            } label: {
                Text(LocalizedStringKey("Delete"))
            }
        }
    }
    
    //MARK: - Parameters
    
    let minSpacerWidth: Double
    @Environment(\.modelContext) var context
    @Binding var message: Message
    @Binding var showStickerDetail: Bool
    @Binding var bottomCardReaction: Reaction?
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll: Bool
    @State var formattedChars: [FormattedChar] = []
    @Binding var glowOriginMessage: UUID?
    @State var reactionContainer = ""
    @State var URLs: [URLRepresentable] = []
    @Binding var showTime: Bool
    @Binding var keyboardShown: Bool
    @Binding var timer: Timer?
    @Binding var replyTo: Reply?
    @Binding var messageToDelete: Message?
    @State var deleteAlertPresented = false
    
    //MARK: -
}
/*
struct BubblePreviewProvider: View {
    @State var showStickerDetail: Bool = false
    @State var bottomCardReaction: Reaction? = nil
    @State var scrollTo: UUID? = nil
    @State var triggerScroll: Bool = false
    @State var glowOriginMessage: UUID? = nil
    @State var messageToDelete: Message? = nil
    @State var showTime: Bool = false
    @State var keyboardShown = false
    @State var timer: Timer? = nil
    @State var message: Message = Message(time: 1704126197, sender: 2, text: "Gute Nacht", reactions: ["\(1)": "🙃", "\(2)": "😆"], messageID: 1)
    var body: some View {
        Bubble(minSpacerWidth: 20, message: $message, showStickerDetail: $showStickerDetail, bottomCardReaction: $bottomCardReaction, reactionCount: 2, reactionData: Reaction(mostUsed: "🙃😆", countString: "2", emojisCount: ["🙃": 1, "😆": 1], differentEmojisCount: 2, peopleReactions: ["\(1)": "🙃", "\(2)": "😆"]), scrollTo: $scrollTo, triggerScroll: $triggerScroll, formattedChars: [FormattedChar(char: "Gute Nacht https://github.com/MiaKoring/BasedChat.git", formats: [])], glowOriginMessage: $glowOriginMessage, messageToDelete: $messageToDelete, URLs: [], showTime: $showTime, keyboardShown: $keyboardShown, timer: $timer)
    }
}

#Preview {
    BubblePreviewProvider()
}
*/

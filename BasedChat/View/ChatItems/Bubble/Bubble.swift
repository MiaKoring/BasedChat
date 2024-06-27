import Foundation
import SwiftUI
import SwiftData

struct Bubble: View, ReactionInfluenced, TimeToggler {
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                if message.senderIsCurrentUser { Spacer(minLength: minSpacerWidth) }
                ZStack(alignment: .bottomTrailing) {
                    VStack(alignment: .leading) {
                        LinkView(URLs: URLs, messageText: message.text)
                        ReplyView(message: message, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage)
                        MessageTextView(message: message, reactionContainer: reactionContainer)
                        if !message.reactions.isEmpty {
                            Text(" ❤️ + ")
                                .frame(height: 0.0)
                                .hidden()
                        }
                    }
                    .padding(message.type.range(of: "reply", options: .caseInsensitive).isNil ? 10 : 5)
                    .padding(.bottom, message.reactions.isEmpty ? 0 : message.type.range(of: "reply", options: .caseInsensitive).isNil ? 10 : 15)
                }
                .bubbleBackground(isCurrent: message.senderIsCurrentUser, background: message.background)
                .overlay(alignment: message.senderIsCurrentUser ? .bottomLeading : .bottomTrailing) {
                    ReactionDisplayView(message: message, bottomCardReaction: $bottomCardReaction, showStickerDetail: $showStickerDetail)
                        .padding(5)
                }
                .contextMenu() {
                    BubbleContextMenu(message: message, replyTo: $replyTo, deleteAlertPresented: $deleteAlertPresented)
                }
                //TODO: add custom popover
                if !message.senderIsCurrentUser { Spacer(minLength: minSpacerWidth) }
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
                    guard let data = reactionData else { return }
                    reactionContainer = "\(data.mostUsed)\(data.differentEmojisCount > 4 ? "+" : "") \(data.countString)"
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
    var message: Message
    @Binding var showStickerDetail: Bool
    @Binding var bottomCardReaction: BuiltReactions?
    @State var reactionData: BuiltReactions? = nil
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll: Bool
    @Binding var glowOriginMessage: UUID?
    @State var reactionContainer = ""
    @State var URLs: [URLRepresentable] = []
    @Binding var showTime: Bool
    @Binding var keyboardShown: Bool
    @Binding var timer: Timer?
    @Binding var replyTo: Message?
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

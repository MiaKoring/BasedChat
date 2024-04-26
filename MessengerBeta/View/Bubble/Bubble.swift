import Foundation
import SwiftUI
import SwiftData

struct Bubble: View, ReactionInfluenced {
    //MARK: - Body
    
    var body: some View {
        VStack{
            HStack{
                if message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
                ZStack(alignment: .bottomTrailing){
                    VStack(alignment: .leading){
                        LinkView(URLs: URLs, messageText: message.text)
                        ReplyView(message: message, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage)
                        MessageTextView(message: message, reactionContainer: $reactionContainer, formattedChars: $formattedChars)
                        
                    }
                    .padding(10)
                    
                    ReactionDisplayView(reactionContainer: reactionContainer, textCount: message.text.count, reactionData: reactionData, sender: message.sender, bottomCardReaction: $bottomCardReaction, bottomCardOpen: $bottomCardOpen)
                        .hidden()
                }
                .bubbleBackground(isCurrent: message.sender.isCurrentUser, background: message.background)//TODO: Replace true
                .overlay(alignment: message.sender.isCurrentUser ? .bottomLeading : .bottomTrailing, content: {
                    ReactionDisplayView(reactionContainer: reactionContainer, textCount: message.text.count, reactionData: reactionData, sender: message.sender, bottomCardReaction: $bottomCardReaction, bottomCardOpen: $bottomCardOpen)
                })
                .contextMenu(){
                    BubbleContextMenu(message: message)
                }
                if !message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
            }
            .background(Color.init("Background"))
            .onTapGesture {
                toggleTime()
            }
            .onAppear(){
                if !message.reactions.isEmpty{
                    reactionData = genReactions()
                    reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
                }
                URLs = extractURLs(from: message.text)
            }
            if showTime{ BubbleTimeDisplayView(message: message) }
        }
    }
    
    //MARK: - Parameters
    
    let minSpacerWidth: Double
    @Environment(\.modelContext) var context
    var message: Message
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction?
    var reactionCount: Float = 0
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll: Bool
    @State var formattedChars: [FormattedChar] = []
    @Binding var glowOriginMessage: UUID?
    @Binding var messageToDelete: Message?
    @State var reactionContainer = ""
    @State var URLs: [URLRepresentable] = []
    @Binding var showTime: Bool
    @Binding var keyboardShown: Bool
    @Binding var timer: Timer?
    
    //MARK: -
}

//MARK: -

struct BubblePreviewProvider: View {
    @State var bottomCardOpen: Bool = false
    @State var bottomCardReaction: Reaction? = nil
    @State var scrollTo: UUID? = nil
    @State var triggerScroll: Bool = false
    @State var glowOriginMessage: UUID? = nil
    @State var messageToDelete: Message? = nil
    @State var showTime: Bool = false
    @State var keyboardShown = false
    @State var timer: Timer? = nil
    var body: some View {
        Bubble(minSpacerWidth: 20, message: Message(chatMessagesID: defaultChat.messagesID, time: 1704126197, sender: 2, text: "Gute Nacht", reactions: ["\(1)": "🙃", "\(2)": "😆"], messageID: 1), bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, reactionCount: 2, reactionData: Reaction(mostUsed: "🙃😆", countString: "2", emojisCount: ["🙃": 1, "😆": 1], differentEmojisCount: 2, peopleReactions: ["\(1)": "🙃", "\(2)": "😆"]), scrollTo: $scrollTo, triggerScroll: $triggerScroll, formattedChars: [FormattedChar(char: "Gute Nacht https://github.com/MiaKoring/BasedChat.git", formats: [])], glowOriginMessage: $glowOriginMessage, messageToDelete: $messageToDelete, URLs: [], showTime: $showTime, keyboardShown: $keyboardShown, timer: $timer)
    }
}

#Preview {
    BubblePreviewProvider()
}

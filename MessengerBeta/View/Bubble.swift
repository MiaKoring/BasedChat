import Foundation
import SwiftUI
import SwiftData

public struct Bubble: View, ReactionInfluenced {
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
    public var body: some View {
        Text("Test")
        VStack{
            HStack{
                if message.sender.isCurrentUser {
                    Spacer(minLength: minSpacerWidth)
                }
                HStack{
                    ZStack(alignment: .bottomTrailing){
                        VStack(alignment: .leading){
                            LinkView(URLs: URLs, messageText: message.text)
                            ReplyView(message: message, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage)
                            MessageTextView(message: message, reactionContainer: $reactionContainer, formattedChars: $formattedChars)
                            
                        }
                        .padding(10)
                        
                        ReactionDisplay(reactionContainer: reactionContainer, textCount: message.text.count, reactionData: reactionData, sender: message.sender, bottomCardReaction: $bottomCardReaction, bottomCardOpen: $bottomCardOpen)
                            .hidden()
                        
                    }
                }
                .bubbleBackground(isCurrent: message.sender.isCurrentUser, background: message.background)//TODO: Replace true
                .overlay(alignment: message.sender.isCurrentUser ? .bottomLeading : .bottomTrailing, content: {
                    ReactionDisplay(reactionContainer: reactionContainer, textCount: message.text.count, reactionData: reactionData, sender: message.sender, bottomCardReaction: $bottomCardReaction, bottomCardOpen: $bottomCardOpen)
                })
                .contextMenu(){
                    //TODO: Make seperate View for context menu
                    Text(DateHandler.formatBoth(message.time, lang: "de_DE"))
                    Button(role: .destructive){
                        messageToDelete = message
                    } label: {
                        Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
                    }
                    
                }
                if !message.sender.isCurrentUser {
                    Spacer(minLength: minSpacerWidth)
                }
            }
            
        }
        .background(Color.init("Background"))
        .onAppear(){
            if !message.reactions.isEmpty{
                reactionData = genReactions()
                reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
            }
            URLs = extractURLs(from: message.text)
        }
    }
}


struct BubblePreviewProvider: View {
    @State var bottomCardOpen: Bool = false
    @State var bottomCardReaction: Reaction? = nil
    @State var scrollTo: UUID? = nil
    @State var triggerScroll: Bool = false
    @State var glowOriginMessage: UUID? = nil
    @State var messageToDelete: Message? = nil
    var body: some View {
         Bubble(minSpacerWidth: 20, message: Message(chatMessagesID: defaultChat.messagesID, time: 1704126197, sender: 2, text: "Gute Nacht", reactions: ["\(1)": "🙃", "\(2)": "😆"], messageID: 1), bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, reactionCount: 2, reactionData: Reaction(mostUsed: "🙃😆", countString: "2", emojisCount: ["🙃": 1, "😆": 1], differentEmojisCount: 2, peopleReactions: ["\(1)": "🙃", "\(2)": "😆"]), scrollTo: $scrollTo, triggerScroll: $triggerScroll, formattedChars: [FormattedChar(char: "Gute Nacht", formats: [])], glowOriginMessage: $glowOriginMessage, messageToDelete: $messageToDelete, URLs: [])
    }
}

#Preview {
    BubblePreviewProvider()
}

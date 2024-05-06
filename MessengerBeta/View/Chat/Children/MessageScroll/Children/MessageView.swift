import SwiftUI
import SwiftChameleon

struct MessageView: View {
    //MARK: - Body
    
    var body: some View {
        LazyVStack {
            ForEach($renderedMessages, id: \.id) { message in
                if message.isSticker {
                    Sticker(message: message, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage, scrollTo: $scrollTo, showTime: $showTime, keyboardShown: $keyboardShown, timer: $timer,
                            replyTo: $replyTo, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, messageToDelete: $messageToDelete, minSpacerWidth: minSpacerWidth)
                        .rotationEffect(.degrees(180.0))
                        .padding(.top, message.wrappedValue.reactions.isEmpty ? 0 : 10)
                        .onDisappear() {
                            if !showBottomScrollButton && message.wrappedValue == renderedMessages.first {
                                showBottomScrollButton = true
                            }
                        }
                        .onAppear() {
                            if message.wrappedValue == renderedMessages.first {
                                showBottomScrollButton = false
                            }
                        }
                }
                else {
                    Bubble(minSpacerWidth: minSpacerWidth, message: message, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage, showTime: $showTime, keyboardShown: $keyboardShown, timer: $timer, replyTo: $replyTo, messageToDelete: $messageToDelete)
                        .id(message.id)
                        .rotationEffect(.degrees(180.0))
                        .onDisappear() {
                            if !showBottomScrollButton && message.wrappedValue == renderedMessages.first{
                                showBottomScrollButton = true
                            }
                        }
                        .onAppear() {
                            if message.wrappedValue == renderedMessages.first {
                                showBottomScrollButton = false
                            }
                        }
                }
                if containsUnread && lastUnreadIndex == renderedMessages.firstIndex(where: {$0.id == message.id}) {
                    HStack {
                        Spacer()
                        Text(LocalizedStringKey("NewMessages"))
                            .font(.custom("JetBrainsMono-Regular", size: 11.75))
                        Spacer()
                    }
                    .padding(3)
                    .background(
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(Color.gray)
                            .opacity(0.4)
                    )
                    .rotationEffect(.degrees(180.0))
                }
            }
            .onChange(of: messageToDelete) {
                if messageToDelete.isNil { return }
                renderedMessages.removeAll(where: { $0.id == messageToDelete!.id })
            }
        }
    }
    
    //MARK: - Parameters

    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction?
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll:  Bool
    @Binding var glowOriginMessage: UUID?
    @State var showTime = false
    @State var timer : Timer? = nil
    @Binding var keyboardShown: Bool
    @Binding var replyTo: Reply?
    @State var tappedID: UUID? = nil
    @State var replyTimer: Timer? = nil
    @Binding var renderedMessages: [Message]
    @Binding var containsUnread: Bool
    @Binding var lastUnreadIndex: Int?
    @Binding var showBottomScrollButton: Bool
    @Binding var messageToDelete: Message?
    #if os(iOS)
    @State var minSpacerWidth: Double = UIScreen.main.bounds.width*0.2
    #else
    @State var minSpacerWidth: Double = 200.0
    #endif
    
    //MARK: -
}

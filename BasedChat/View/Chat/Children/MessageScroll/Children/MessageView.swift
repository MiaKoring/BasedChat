import SwiftUI
import SwiftChameleon
import RealmSwift

struct MessageView: View {
    //MARK: - Body
    
    var body: some View {
        LazyVStack {
            ForEach(messages) { message in
                if message.isSticker {
                    StickerView(message: message, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage, scrollTo: $scrollTo, showTime: $showTime, keyboardShown: $keyboardShown, timer: $timer,
                            replyTo: $replyTo, showStickerDetail: $showStickerDetail, bottomCardReaction: $bottomCardReaction, messageToDelete: $messageToDelete, minSpacerWidth: minSpacerWidth)
                        .id(message.messageUUID)
                        .rotationEffect(.degrees(180.0))
                        .padding(.top, message.reactions.isEmpty ? 0 : 10)
                        .onDisappear() {
                            if !showBottomScrollButton && message == messages.first {
                                showBottomScrollButton = true
                            }
                        }
                        .onAppear() {
                            if message == messages.first {
                                showBottomScrollButton = false
                            }
                        
                        }
                }
                else {
                    Bubble(minSpacerWidth: minSpacerWidth, message: message, showStickerDetail: $showStickerDetail, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage, showTime: $showTime, keyboardShown: $keyboardShown, timer: $timer, replyTo: $replyTo, messageToDelete: $messageToDelete)
                        .id(message.messageUUID)
                        .rotationEffect(.degrees(180.0))
                        .onDisappear() {
                            if !showBottomScrollButton && message == messages.first{
                                showBottomScrollButton = true
                            }
                        }
                        .onAppear() {
                            if message == messages.first {
                                showBottomScrollButton = false
                            }
                        }
                }/*
                if containsUnread && lastUnreadIndex == messages.firstIndex(where: {$0.messageUUID == message.messageUUID}) {
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
                }*/
            }
            /*.onChange(of: messageToDelete) {
                if messageToDelete.isNil { return }
                
                messages.removeAll(where: { $0.messageUUID == messageToDelete!.messageUUID })
            }*/
        }
    }
    
    //MARK: - Parameters

    @ObservedResults(Message.self) var messages
    @Binding var showStickerDetail: Bool
    @Binding var bottomCardReaction: BuiltReactions?
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll:  Bool
    @Binding var glowOriginMessage: UUID?
    @State var showTime = false
    @State var timer : Timer? = nil
    @Binding var keyboardShown: Bool
    @Binding var replyTo: Message?
    @State var tappedID: UUID? = nil
    @State var replyTimer: Timer? = nil
    @Binding var containsUnread: Bool
    @Binding var lastUnreadIndex: Int?
    @Binding var showBottomScrollButton: Bool
    @Binding var messageToDelete: Message?
    #if os(iOS)
    @State var minSpacerWidth: Double = UIScreen.main.bounds.width*0.2
    #else
    @State var minSpacerWidth: Double = 200.0
    #endif
    
    init(chatID: ObjectId, showStickerDetail: Binding<Bool>, bottomCardReaction: Binding<BuiltReactions?>, scrollTo: Binding<UUID?>, triggerScroll: Binding<Bool>, glowOriginMessage: Binding<UUID?>, keyboardShown: Binding<Bool>, replyTo: Binding<Message?>, containsUnread: Binding<Bool>, lastUnreadIndex: Binding<Int?>, showBottomScrollButton: Binding<Bool>, messageToDelete: Binding<Message?>) {
        let sort = SortDescriptor(keyPath: "messageID", ascending: false)
        self._messages = ObservedResults(Message.self, where: {
            $0.chat._id == chatID
        }, sortDescriptor: sort)
        self._showStickerDetail = showStickerDetail
        self._bottomCardReaction = bottomCardReaction
        self._scrollTo = scrollTo
        self._triggerScroll = triggerScroll
        self._glowOriginMessage = glowOriginMessage
        self._keyboardShown = keyboardShown
        self._replyTo = replyTo
        self._containsUnread = containsUnread
        self._lastUnreadIndex = lastUnreadIndex
        self._showBottomScrollButton = showBottomScrollButton
        self._messageToDelete = messageToDelete
    }
}

import SwiftUI
import RealmSwift

struct MessageScrollView: View {
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ScrollViewReader { reader in
                    MessageView(chatID: chat._id, showStickerDetail: $showStickerDetail, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage, keyboardShown: $keyboardShown, replyTo: $replyTo, containsUnread: $containsUnread, lastUnreadIndex: $lastUnreadIndex, showBottomScrollButton: $showBottomScrollButton, messageToDelete: $messageToDelete, appendMessage: $appendMessage)
                        .onChange(of: triggerBottomScroll) {
                            withAnimation(.smooth(duration: 0.3)) {
                                reader.scrollTo(chat.messages.sorted(by: {
                                    $0.messageID > $1.messageID
                                }).first?.messageUUID, anchor: .top)
                            }
                        }
                        .onChange(of: triggerScroll) {
                            //loadScrollDestination()
                            
                            withAnimation(.smooth(duration: 0.2)) {
                                reader.scrollTo(scrollTo, anchor: .top)
                            }
                        }
                        .onChange(of: newMessageSent) {
                            //newMessage()
                        }
                    Rectangle()
                        .hidden()
                        .frame(width: 0, height: 0)
                        .padding(.top, 110)
                    Spacer()
                }
            }
            .defaultScrollAnchor(.top)
            .scrollIndicators(.hidden)
        }
        .rotationEffect(.degrees(180.0))
        .overlay(alignment: .bottomTrailing) {
            bottomScrollOverlay()
        }
        .onAppear() {
            //setup()
        }
        .onDisappear() {
            //markAllRead()
        }
        .onChange(of: scenePhase) { newScenePhase, _ in
            //scenePhaseChanged(newScenePhase: newScenePhase)
        }
        .onChange(of: glowOriginMessage) {
            messageGlow()
        }
    }
    
    //MARK: - Parameters
    
    @ObservedRealmObject var chat: Chat
    @Binding var showStickerDetail: Bool
    @Binding var bottomCardReaction: BuiltReactions?
    @State var scrollTo: UUID? = nil
    @State var triggerScroll: Bool = false
    @Binding var replyTo: Message?
    @Binding var newMessageSent: Bool
    @State var triggerBottomScroll = false
    @State var glowOriginMessage: UUID? = nil
    @State var startIndex = 500000
    @State var endIndex = 500000
    @State var rangeStart: Int = 0
    @State var rangeEnd: Int = 0
    @State var containsUnread = false
    @State var lastUnreadIndex: Int? = nil
    @Environment(\.scenePhase) var scenePhase
    @Binding var messageToDelete: Message?
    @Binding var appendMessage: Message?
    @Binding var keyboardShown: Bool
    @State var showBottomScrollButton: Bool = false
    
    //MARK: -
}


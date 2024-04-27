import SwiftUI

struct MessageScrollView: View {
    //MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{reader in
                    MessageView(bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage, keyboardShown: $keyboardShown, replyTo: $replyTo, renderedMessages: $renderedMessages, containsUnread: $containsUnread, lastUnreadIndex: $lastUnreadIndex, showBottomScrollButton: $showBottomScrollButton, messageToDelete: $messageToDelete)
                        .onChange(of: triggerBottomScroll){
                            withAnimation(.smooth(duration: 0.3)){
                                reader.scrollTo(renderedMessages.first?.id)
                            }
                        }
                        .onChange(of: triggerScroll){
                            loadScrollDestination()
                            withAnimation(.smooth(duration: 0.2)){
                                reader.scrollTo(scrollTo, anchor: .top)
                            }
                        }
                        .onChange(of: newMessageSent){
                            newMessage()
                        }
                    if rangeStart > 0{
                        ProgressView()
                            .onAppear(){
                                let previousStart = rangeStart - 1
                                rangeStart = max(rangeStart - 50, 0)
                                renderedMessages.append(contentsOf: messages[rangeStart...previousStart].reversed())
                            }
                    }
                    else{
                        Rectangle()
                            .hidden()
                            .frame(width: 0, height: 0)
                            .padding(.top, 50)
                    }
                    Spacer()
                }
            }
            .defaultScrollAnchor(.top)
            .scrollIndicators(.hidden)
        }
        .rotationEffect(.degrees(180.0))
        .overlay(alignment: .bottomTrailing){
            bottomScrollOverlay()
        }
        .onAppear(){
            setup()
        }
        .onDisappear(){
            markAllRead()
        }
        .onChange(of: scenePhase) { newScenePhase, _ in
            scenePhaseChanged(newScenePhase: newScenePhase)
        }
        .onChange(of: messageToDelete){
            
        }
    }
    
    //MARK: - Parameters
    
    let messages: [Message]
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction?
    @State var scrollTo: UUID? = nil
    @State var triggerScroll: Bool = false
    @Binding var replyTo: Reply?
    @Binding var newMessageSent: Bool
    @State var showBottomScrollButton = false
    @State var triggerBottomScroll = false
    @State var renderedMessages: [Message] = []
    @State var glowOriginMessage: UUID? = nil {
        didSet{
            messageGlow()
        }
    }
    @State var startIndex = 500000
    @State var endIndex = 500000
    @State var rangeStart: Int = 0
    @State var rangeEnd: Int = 0
    @State var containsUnread = false
    @State var lastUnreadIndex: Int? = nil
    @Environment(\.modelContext) var context
    @Environment(\.scenePhase) var scenePhase
    @Binding var messageToDelete: Message?
    @Binding var keyboardShown: Bool
    
    //MARK: -
}


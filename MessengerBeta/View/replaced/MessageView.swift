
/*
struct MessageViewOld: View {
    let messagesID: UUID
    @Environment(\.modelContext) var context
    @Environment(\.scenePhase) private var scenePhase
    @Query var messages: [Message]
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll:  Bool
    @State var glowOriginMessage: UUID? = nil
    @State var allowPageUp = true
    @State var allowPageDown = false
    @Binding var showLoading: Bool
    @State var showTime = false
    @State var timer : Timer? = nil
    @State var currentDate = ""
    @State var keyboardShown = false
    @Binding var replyTo: Reply?
    @State var startIndex = 500000
    @State var endIndex = 500000
    @State var rangeStart: Int = 0
    @State var rangeEnd: Int = 0
    @State var renderedMessages: [Message] = []
    @State var tappedID: UUID? = nil
    @State var replyTimer: Timer? = nil
    @State var showBottomscrollButton = false
    @State var triggerBottomScroll = false
    @Binding var newMessageSent: Bool
    @State var messageToDelete: Message? = nil
    @State var containsUnread = false
    @State var lastUnreadIndex: Int? = nil
    #if os(iOS)
    @State var minSpacerWidth: Double = UIScreen.main.bounds.width*0.2
    #else
    @State var minSpacerWidth: Double = 200.0
    #endif
    
    init(messagesID: UUID, scrollTo: Binding<UUID?>, triggerScroll: Binding<Bool>, bottomCardOpen: Binding<Bool>, bottomCardReaction: Binding<Reaction>, showLoading: Binding<Bool>, replyTo: Binding<Reply?>, newMessageSent: Binding<Bool>){
        self.messagesID = messagesID
        self._scrollTo = scrollTo
        self._triggerScroll = triggerScroll
        self._bottomCardOpen = bottomCardOpen
        self._bottomCardReaction = bottomCardReaction
        self._showLoading = showLoading
        self._replyTo = replyTo
        self._newMessageSent = newMessageSent
    }
   
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{reader in
                    LazyVStack{
                        ForEach($renderedMessages){message in
                            Bubble(minSpacerWidth: minSpacerWidth, message: message, bottomCardOpen: $bottomCardOpen, triggerScroll: $triggerScroll, showTime: $showTime, keyboardShown: $keyboardShown)
                                .id(message.id)
                                .rotationEffect(.degrees(180.0))
                                .onDisappear(){
                                    if !showBottomscrollButton && message.wrappedValue == renderedMessages.first{
                                        showBottomscrollButton = true
                                    }
                                }
                                .onAppear(){
                                    if message.wrappedValue == renderedMessages.first{
                                        showBottomscrollButton = false
                                    }
                                }
                                
                                if showTime{
                                    HStack(){
                                        Spacer()
                                        Text(DateHandler.formatTime(message.time.wrappedValue, lang: "de_DE"))
                                            .font(.custom("JetBrainsMono-Regular", size: 10))
                                    }
                                    .rotationEffect(.degrees(180.0))
                                }
                            if containsUnread && lastUnreadIndex == renderedMessages.firstIndex(where: {$0.id == message.id}){
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
                    }
                    .onChange(of: triggerBottomScroll){
                        withAnimation(.smooth(duration: 0.3)){
                            reader.scrollTo(renderedMessages.first?.id)
                        }
                    }
                    .onChange(of: triggerScroll){
                        if renderedMessages.firstIndex(where: {$0.id == scrollTo}) == nil{
                            let index = messages.firstIndex(where: {$0.id == scrollTo})
                            if index == nil { return }
                            let previousStart = rangeStart
                            rangeStart = max(index! - 5, 0)
                            renderedMessages.append(contentsOf: messages[rangeStart...previousStart - 1].reversed())
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            withAnimation(.smooth(duration: 0.2)){
                                reader.scrollTo(scrollTo, anchor: .top)
                            }
                        }
                    }
                    .onChange(of: newMessageSent){
                        triggerBottomScroll.toggle()
                        rangeStart = messages.count - 51
                        rangeEnd = messages.count - 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            withAnimation(.smooth(duration: 0.3)){
                                renderedMessages = messages[rangeStart...rangeEnd].reversed()
                            }
                        }
                    }
                    .onChange(of: messageToDelete){
                        if messageToDelete == nil { return }
                        renderedMessages.removeAll(where: {$0.id == messageToDelete!.id})
                        context.delete(messageToDelete!)
                        rangeEnd = messages.count - 1
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(10)
            .rotationEffect(.degrees(180.0))
            /*VStack{
                HStack{
                    Text(currentDate)
                        .padding(3)
                        .font(.footnote)
                        .background(){
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(Color.init("DateDisplay"))
                        }
                }
                .padding(.top, 10)
                Spacer()
            }*/
        }
        .onAppear(){
            rangeStart = messages.count - 51
            rangeEnd = messages.count - 1
            renderedMessages = Array(messages[rangeStart...rangeEnd]).reversed()
            containsUnread = renderedMessages.contains(where: {!$0.isRead})
            lastUnreadIndex = containsUnread ? renderedMessages.lastIndex(where: {!$0.isRead}) : nil
        }
        .onDisappear(){
            markAllRead()
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                break
            case .inactive:
                markAllRead()
                break
            case .background:
                markAllRead()
                break
            @unknown default:
                // Handhabung für zukünftige Szenenphasen
                break
            }
        }
        .onChange(of: renderedMessages){
            containsUnread = renderedMessages.contains(where: {!$0.isRead})
            lastUnreadIndex = containsUnread ? renderedMessages.lastIndex(where: {!$0.isRead}) : nil
        }
        .defaultScrollAnchor(.top)
        .onChange(of: glowOriginMessage){
            let glowMessage = glowOriginMessage
            glowOriginMessage = nil
            if glowMessage != nil && messages.contains(where: {$0.id == glowMessage!}){
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                    withAnimation(.easeIn){
                        messages.first(where: {$0.id == glowMessage})!.background = "glow"
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.25){
                        withAnimation(.easeIn){
                            messages.first(where: {$0.id == glowMessage})!.background = "normal"
                        }
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)){_ in
            self.keyboardShown = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)){_ in
            self.keyboardShown = false
        }
        .overlay(alignment: .bottomTrailing){
            if showBottomscrollButton{
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
                    .overlay{
                        Image(systemName: "arrowtriangle.down")
                            .allowsHitTesting(false)
                    }
                    .onTapGesture{
                        triggerBottomScroll.toggle()
                        rangeStart = messages.count - 51
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            renderedMessages = messages[rangeStart...rangeEnd].reversed()
                        }
                    }
            }
        }
    }
    
    
    
}

*/

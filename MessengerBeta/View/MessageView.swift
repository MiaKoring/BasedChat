//
//  ChatView.swift
//  MessengerBeta
//
//  Created by Mia Koring on 07.01.24.
//
/*
import SwiftUI
import SwiftData
*/
let defaultChat = Chat(title: "lelele", participants: ["me", "you"])
/*
//let defaultMessages: [Message] = [Message(chatMessagesID: defaultChat.messagesID, time: 1704126197, sender: "me", text: "Gute Nacht", reactions: ["me": "🙃", "you": "😆"], messageID: 1), Message(chatMessagesID: defaultChat.messagesID, time: 1704191292, sender: "me", text: "Hey, hast du grad Zeit? Wir wollten mal noch unser Wochende planen 😅", messageID: 2), Message(chatMessagesID: defaultChat.messagesID, time: 1704191343, sender: "you", text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", id: testMessageUUID, messageID: 3), Message(chatMessagesID: defaultChat.messagesID, time: 1704191415, sender: "you", text: "So habe ich geschaut. Es klappt. Hast du die anderen schon gefragt?", messageID: 4), Message(chatMessagesID: defaultChat.messagesID, time: 1704191432, sender: "me", text: "Ja, die haben alle Zeit", messageID: 5), Message(chatMessagesID: defaultChat.messagesID, time: 1704191443, sender: "me", text: "womit wollen wir anfangen?", messageID: 6), Message(chatMessagesID: defaultChat.messagesID, time: 1704191482, sender: "you", text: "Ich würde vorschlagen das wir erstmal in ein schönes Restaurant gehen. Ich hätte das La Casa im Blick.", messageID: 7), Message(chatMessagesID: defaultChat.messagesID, time: 1704191531, sender: "me", text: "gibt es da auch was veganes auf der Speisekarte?", messageID: 8), Message(chatMessagesID: defaultChat.messagesID, time: 1704191592, sender: "you", text: "Das", reactions: ["me": "🙃", "you": "😆"], messageID: 9), Message(chatMessagesID: defaultChat.messagesID, time: 1704191603, sender: "you", text: "Oder war es doch Tom ?", messageID: 10), Message(chatMessagesID: defaultChat.messagesID, time: 1704191655, sender: "you", text: "Ich bringe das grade etwas durcheinander. Vielleicht kannst du nochmal nachfragen. Du hast die Nummern von denen.", messageID: 11), Message(chatMessagesID: defaultChat.messagesID, time: 1704191703, sender: "me", text: "Anna war es. Sie verträgt kein Gluten", messageID: 12), Message(chatMessagesID: defaultChat.messagesID, time: 1704191717, sender: "me", text: "Gut dass du dran denkst", messageID: 13), Message(chatMessagesID: defaultChat.messagesID, time: 1704191727, sender: "me", text: "hatte ich grade garnicht auf dem schirm", messageID: 14), Message(chatMessagesID: defaultChat.messagesID, time: 1704191733, sender: "you", text: "Perfekt, dann rufe ich dort später mal an. Soll ich noch jemanden abholen ? Und, wenn ja könntest du mir die Adressen weiterleiten ? Würde sich anbieten da sie auf dem Weg liegen und dann müssen wir nicht mit so vielen Autos fahren.", messageID: 15), Message(chatMessagesID: defaultChat.messagesID, time: 1704191892, sender: "me", text: "Ja, mich und Luca wäre super. Meine Addresse kennst du ja, Luca wohnt im Randomweg 787", messageID: 16), Message(chatMessagesID: defaultChat.messagesID, time: 1704191965, sender: "you", text: "Alles klar. Habe ich dann jetzt direkt im Navi abgespeichert. Passt es dann Luca, wenn ich ihn als erstes abhole?", messageID: 17), Message(chatMessagesID: defaultChat.messagesID, time: 1704191975, sender: "me", text: "Ja klar", messageID: 18), Message(chatMessagesID: defaultChat.messagesID, time: 1704192007, sender: "you", text: "Wäre dann so um ca 18 Uhr vor seiner Haustür.", messageID: 19), Message(chatMessagesID: defaultChat.messagesID, time: 1704192018, sender: "me", text: "super, gebe ich weiter", messageID: 20), Message(chatMessagesID: defaultChat.messagesID, time: 1704192037, sender: "me", text: "Er freut sich", messageID: 21), Message(chatMessagesID: defaultChat.messagesID, time: 1704192082, sender: "you", text: "Perfekt, ich mich auch. Sollte noch was sein melde dich einfach.", messageID: 22), Message(chatMessagesID: defaultChat.messagesID, time: 1704192129, sender: "me", text: "Mach ich, bis dann", messageID: 23), Message(chatMessagesID: defaultChat.messagesID, time: 1704566685, sender: "me", text: "Hallo~ ich _bin *Mia_ lol* ~Test _123_~", messageID: 24)]


struct MessageView: View {
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
    
    init(messagesID: UUID, scrollTo: Binding<UUID?>, triggerScroll: Binding<Bool>, bottomCardOpen: Binding<Bool>, bottomCardReaction: Binding<Reaction>, showLoading: Binding<Bool>, replyTo: Binding<Reply?>, newMessageSent: Binding<Bool>){
        self.messagesID = messagesID
        self._scrollTo = scrollTo
        self._triggerScroll = triggerScroll
        self._bottomCardOpen = bottomCardOpen
        self._bottomCardReaction = bottomCardReaction
        self._showLoading = showLoading
        self._replyTo = replyTo
        var fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(\Message.messageID, order: .forward)])
        fetchDescriptor.predicate = #Predicate{
            $0.chatMessagesID == messagesID
        }
        self._messages = Query(fetchDescriptor)
        self._newMessageSent = newMessageSent
    }
   
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{reader in
                    LazyVStack{
                        ForEach($renderedMessages){message in
                            if message.sender.wrappedValue == "me" {
                                MeMSG(
                                    message: message.wrappedValue,
                                    pos: "top",
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    triggerScroll: $triggerScroll,
                                    glowOriginMessage: $glowOriginMessage,
                                    messageToDelete: $messageToDelete
                                )
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
                                .onTapGesture(){
                                    if !keyboardShown{
                                       if tappedID == message.id{
                                            if replyTimer != nil{
                                                replyTimer!.invalidate()
                                                replyTimer = nil
                                            }
                                            tappedID = nil
                                            replyTo = Reply(originID: message.wrappedValue.id, text: message.wrappedValue.text, sender: message.wrappedValue.sender)
                                        }
                                        else{
                                            tappedID = message.id
                                            replyTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){_ in
                                                tappedID = nil
                                                withAnimation {
                                                    showTime.toggle()
                                                }
                                                if showTime{
                                                    timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false){_ in
                                                        withAnimation {
                                                            showTime = false
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        hideKeyboard()
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
                            }
                            else{
                                YouMSG(
                                    message: message.wrappedValue,
                                    pos: "top",
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    triggerScroll: $triggerScroll,
                                    glowOriginMessage: $glowOriginMessage,
                                    messageToDelete: $messageToDelete
                                )
                                .id(message.id)
                                .rotationEffect(.degrees(180.0))
                                .onAppear(){
                                    if rangeStart > 0{
                                        rangeStart = max(rangeStart - 50, 0)
                                    }
                                }
                                .onTapGesture(){
                                    if !keyboardShown{
                                        if showTime{
                                            withAnimation(.easeOut(duration: 0.1)){
                                                showTime = false
                                            }
                                        }
                                        else{
                                            withAnimation(.easeIn(duration: 0.1)){
                                                showTime = true
                                            }
                                            if timer != nil && timer!.isValid{
                                                timer!.invalidate()
                                            }
                                            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false){timer in
                                                withAnimation(.easeOut(duration: 0.1)){
                                                    showTime = false
                                                    timer.invalidate()
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        hideKeyboard()
                                    }
                                }
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
                                        Text(DateHandler.formatTime(message.time.wrappedValue, lang: "de_DE"))
                                            .font(.custom("JetBrainsMono-Regular", size: 10))
                                        Spacer()
                                    }
                                    .rotationEffect(.degrees(180.0))
                                }
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
    
    
    func markAllRead(){
        for message in (messages.compactMap{message in
            if !message.isRead{
                return message
            }
            return nil
        }){
            message.isRead = true
        }
    }
}
*/

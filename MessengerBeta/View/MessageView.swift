//
//  ChatView.swift
//  MessengerBeta
//
//  Created by Mia Koring on 07.01.24.
//

import SwiftUI
import SwiftData

let defaultChat = Chat(title: "lelele", participants: ["me", "you"])
let defaultMessages: [Message] = [Message(chatMessagesID: defaultChat.messagesID, time: 1704126197, sender: "me", text: "Gute Nacht", reactions: ["me": "🙃", "you": "😆"], messageID: 1), Message(chatMessagesID: defaultChat.messagesID, time: 1704191292, sender: "me", text: "Hey, hast du grad Zeit? Wir wollten mal noch unser Wochende planen 😅", messageID: 2), Message(chatMessagesID: defaultChat.messagesID, time: 1704191343, sender: "you", text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", id: testMessageUUID, messageID: 3), Message(chatMessagesID: defaultChat.messagesID, time: 1704191415, sender: "you", text: "So habe ich geschaut. Es klappt. Hast du die anderen schon gefragt?", messageID: 4), Message(chatMessagesID: defaultChat.messagesID, time: 1704191432, sender: "me", text: "Ja, die haben alle Zeit", messageID: 5), Message(chatMessagesID: defaultChat.messagesID, time: 1704191443, sender: "me", text: "womit wollen wir anfangen?", messageID: 6), Message(chatMessagesID: defaultChat.messagesID, time: 1704191482, sender: "you", text: "Ich würde vorschlagen das wir erstmal in ein schönes Restaurant gehen. Ich hätte das La Casa im Blick.", messageID: 7), Message(chatMessagesID: defaultChat.messagesID, time: 1704191531, sender: "me", text: "gibt es da auch was veganes auf der Speisekarte?", messageID: 8), Message(chatMessagesID: defaultChat.messagesID, time: 1704191592, sender: "you", text: "Das", reactions: ["me": "🙃", "you": "😆"], messageID: 9), Message(chatMessagesID: defaultChat.messagesID, time: 1704191603, sender: "you", text: "Oder war es doch Tom ?", messageID: 10), Message(chatMessagesID: defaultChat.messagesID, time: 1704191655, sender: "you", text: "Ich bringe das grade etwas durcheinander. Vielleicht kannst du nochmal nachfragen. Du hast die Nummern von denen.", messageID: 11), Message(chatMessagesID: defaultChat.messagesID, time: 1704191703, sender: "me", text: "Anna war es. Sie verträgt kein Gluten", messageID: 12), Message(chatMessagesID: defaultChat.messagesID, time: 1704191717, sender: "me", text: "Gut dass du dran denkst", messageID: 13), Message(chatMessagesID: defaultChat.messagesID, time: 1704191727, sender: "me", text: "hatte ich grade garnicht auf dem schirm", messageID: 14), Message(chatMessagesID: defaultChat.messagesID, time: 1704191733, sender: "you", text: "Perfekt, dann rufe ich dort später mal an. Soll ich noch jemanden abholen ? Und, wenn ja könntest du mir die Adressen weiterleiten ? Würde sich anbieten da sie auf dem Weg liegen und dann müssen wir nicht mit so vielen Autos fahren.", messageID: 15), Message(chatMessagesID: defaultChat.messagesID, time: 1704191892, sender: "me", text: "Ja, mich und Luca wäre super. Meine Addresse kennst du ja, Luca wohnt im Randomweg 787", messageID: 16), Message(chatMessagesID: defaultChat.messagesID, time: 1704191965, sender: "you", text: "Alles klar. Habe ich dann jetzt direkt im Navi abgespeichert. Passt es dann Luca, wenn ich ihn als erstes abhole?", messageID: 17), Message(chatMessagesID: defaultChat.messagesID, time: 1704191975, sender: "me", text: "Ja klar", messageID: 18), Message(chatMessagesID: defaultChat.messagesID, time: 1704192007, sender: "you", text: "Wäre dann so um ca 18 Uhr vor seiner Haustür.", messageID: 19), Message(chatMessagesID: defaultChat.messagesID, time: 1704192018, sender: "me", text: "super, gebe ich weiter", messageID: 20), Message(chatMessagesID: defaultChat.messagesID, time: 1704192037, sender: "me", text: "Er freut sich", messageID: 21), Message(chatMessagesID: defaultChat.messagesID, time: 1704192082, sender: "you", text: "Perfekt, ich mich auch. Sollte noch was sein melde dich einfach.", messageID: 22), Message(chatMessagesID: defaultChat.messagesID, time: 1704192129, sender: "me", text: "Mach ich, bis dann", messageID: 23), Message(chatMessagesID: defaultChat.messagesID, time: 1704566685, sender: "me", text: "Hallo~ ich _bin *Mia_ lol* ~Test _123_~", messageID: 24)]


struct MessageView: View {
    let messagesID: UUID
    @Environment(\.modelContext) var context
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
    init(messagesID: UUID, scrollTo: Binding<UUID?>, triggerScroll: Binding<Bool>, bottomCardOpen: Binding<Bool>, bottomCardReaction: Binding<Reaction>, showLoading: Binding<Bool>, replyTo: Binding<Reply?>){
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
        _messages = Query(fetchDescriptor)
    }
   
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{reader in
                    LazyVStack{
                        ForEach($renderedMessages, id: \.self){message in
                            if message.sender.wrappedValue == "me" {
                                MeMSG(
                                    message: message.wrappedValue,
                                    pos: "top",
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    triggerScroll: $triggerScroll,
                                    glowOriginMessage: $glowOriginMessage
                                )
                                .rotationEffect(.degrees(180.0))
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
                                
                            }
                            else{
                                YouMSG(
                                    message: message.wrappedValue,
                                    pos: "top",
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    triggerScroll: $triggerScroll,
                                    glowOriginMessage: $glowOriginMessage
                                )
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
                    }
                }
            }
            .rotationEffect(.degrees(180.0))
            VStack{
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
            }
        }
        .onAppear(){
            rangeStart = messages.count - 51
            rangeEnd = messages.count - 1
            renderedMessages = Array(messages[rangeStart...rangeEnd]).reversed()
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                let previousStart = rangeStart - 1
                rangeStart = max(rangeStart - 50, 0)
                renderedMessages.append(contentsOf: messages[rangeStart...previousStart].reversed())
            }*/
        }
        .defaultScrollAnchor(.top)
        .onChange(of: glowOriginMessage){
            let glowMessage = glowOriginMessage
            glowOriginMessage = nil
            if glowMessage != nil && messages.contains(where: {$0.id == glowMessage!}){
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                    withAnimation(.easeIn){
                        messages.first(where: {$0.id == glowMessage})!.background = "glow"
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
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
    }
    
    func hideKeyboard()->Void{
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

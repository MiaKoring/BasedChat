//
//  ChatView.swift
//  MessengerBeta
//
//  Created by Mia Koring on 07.01.24.
//

import SwiftUI
import SwiftData

let defaultChat = Chat(title: "lelele", participants: ["me", "you"])
let defaultMessages: [Message] = [Message(chatMessagesID: defaultChat.messagesID, time: 1704126197, sender: "me", text: "Gute Nacht", reactions: ["me": "🙃", "you": "😆"]), Message(chatMessagesID: defaultChat.messagesID, time: 1704191292, sender: "me", text: "Hey, hast du grad Zeit? Wir wollten mal noch unser Wochende planen 😅"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191343, sender: "you", text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", id: testMessageUUID), Message(chatMessagesID: defaultChat.messagesID, time: 1704191415, sender: "you", text: "So habe ich geschaut. Es klappt. Hast du die anderen schon gefragt?"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191432, sender: "me", text: "Ja, die haben alle Zeit"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191443, sender: "me", text: "womit wollen wir anfangen?"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191482, sender: "you", text: "Ich würde vorschlagen das wir erstmal in ein schönes Restaurant gehen. Ich hätte das La Casa im Blick."), Message(chatMessagesID: defaultChat.messagesID, time: 1704191531, sender: "me", text: "gibt es da auch was veganes auf der Speisekarte?"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191592, sender: "you", text: "Das", reactions: ["me": "🙃", "you": "😆"]), Message(chatMessagesID: defaultChat.messagesID, time: 1704191603, sender: "you", text: "Oder war es doch Tom ?"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191655, sender: "you", text: "Ich bringe das grade etwas durcheinander. Vielleicht kannst du nochmal nachfragen. Du hast die Nummern von denen."), Message(chatMessagesID: defaultChat.messagesID, time: 1704191703, sender: "me", text: "Anna war es. Sie verträgt kein Gluten"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191717, sender: "me", text: "Gut dass du dran denkst"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191727, sender: "me", text: "hatte ich grade garnicht auf dem schirm"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191733, sender: "you", text: "Perfekt, dann rufe ich dort später mal an. Soll ich noch jemanden abholen ? Und, wenn ja könntest du mir die Adressen weiterleiten ? Würde sich anbieten da sie auf dem Weg liegen und dann müssen wir nicht mit so vielen Autos fahren."), Message(chatMessagesID: defaultChat.messagesID, time: 1704191892, sender: "me", text: "Ja, mich und Luca wäre super. Meine Addresse kennst du ja, Luca wohnt im Randomweg 787"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191965, sender: "you", text: "Alles klar. Habe ich dann jetzt direkt im Navi abgespeichert. Passt es dann Luca, wenn ich ihn als erstes abhole?"), Message(chatMessagesID: defaultChat.messagesID, time: 1704191975, sender: "me", text: "Ja klar"), Message(chatMessagesID: defaultChat.messagesID, time: 1704192007, sender: "you", text: "Wäre dann so um ca 18 Uhr vor seiner Haustür."), Message(chatMessagesID: defaultChat.messagesID, time: 1704192018, sender: "me", text: "super, gebe ich weiter"), Message(chatMessagesID: defaultChat.messagesID, time: 1704192037, sender: "me", text: "Er freut sich"), Message(chatMessagesID: defaultChat.messagesID, time: 1704192082, sender: "you", text: "Perfekt, ich mich auch. Sollte noch was sein melde dich einfach."), Message(chatMessagesID: defaultChat.messagesID, time: 1704192129, sender: "me", type: "reply", reply: Reply(originID: testMessageUUID, text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", sender: "You"), text: "Mach ich, bis dann"), Message(chatMessagesID: defaultChat.messagesID, time: 1704566685, sender: "me", text: "Hallo~ ich _bin *Mia_ lol* ~Test _123_~")]
/*struct ChatView: View {
    @State var bottomCardOpen = false
    @State var bottomCardReaction: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @State var scrollTo = UUID()
    @Binding var messages: [Message]
    @State var triggerScroll = false
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{proxy in
                    LazyVStack(spacing: 8){
                        ForEach(0..<messages.count){ index in
                            if index == 0{
                                HStack{
                                    Spacer()
                                    Text(messages[index].time.split(separator: " ")[0])
                                        .font(Font.custom("JetBrainsMono-Regular", size: 12))
                                        .padding(2)
                                    Spacer()
                                }
                                .background(){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.init("DateDisplay"))
                                }
                                .onChange(of: triggerScroll){
                                    if triggerScroll{
                                        withAnimation(.easeIn(duration: 0.15)){
                                            proxy.scrollTo(scrollTo, anchor: .top)
                                        }
                                        triggerScroll.toggle()
                                    }
                                }
                            }
                            if messages[index].sender == "me" {
                                MeMSG(message: messages[index], pos: index-1 < 0 || messages[index-1].sender != messages[index].sender || messages[index - 1].time.split(separator: " ")[0] !=  messages[index].time.split(separator: " ")[0]  ? "top" : "bottom", nextTime: index + 1 < messages.count && messages[index+1].sender == messages[index].sender ? messages[index + 1].time : nil, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: messages, triggerScroll: $triggerScroll)
                                    .padding(.top, index - 1 >= 0 && messages[index].sender != messages[index-1].sender ? 4 : 0)
                                    .id(messages[index].id)
                            }
                            else{
                                YouMSG(message: messages[index], pos: index-1 < 0 || messages[index-1].sender == "me" ? "top" : "bottom", nextTime: index + 1 < messages.count && messages[index+1].sender == messages[index].sender ? messages[index + 1].time : nil, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: messages, triggerScroll: $triggerScroll)
                                    .padding(.top, index - 1 >= 0 && messages[index].sender != messages[index-1].sender ? 4 : 0)
                                    .id(messages[index].id)
                            }
                            if index + 1 < messages.count && messages[index].time.split(separator: " ")[0] != messages[index + 1].time.split(separator: " ")[0]{
                                HStack{
                                    Spacer()
                                    Text(messages[index + 1].time.split(separator: " ")[0])
                                        .font(Font.custom("JetBrainsMono-Regular", size: 12))
                                        .padding(2)
                                    Spacer()
                                }
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.init("DateDisplay"))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .defaultScrollAnchor(.bottom)
            .padding(.top, 1)
            .padding(.bottom, 40)
            
            if(bottomCardOpen){
                BottomCard(content: {ReactionOverview(reaction: $bottomCardReaction, emojis: Array(bottomCardReaction.emojisCount.keys))}, isOpen: $bottomCardOpen)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}*/


struct ChatView: View {
    let messagesID: UUID
    @Environment(\.modelContext) var context
    @Query var messages: [Message]
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction
    @Binding var scrollTo: UUID
    @Binding var triggerScroll:  Bool
    @State var glowOriginMessage: UUID? = nil
    @State var allowPageUp = true
    @State var allowPageDown = false
    @Binding var pageBinding: Int
    @Binding var showLoading: Bool
    @State var showTime = false
    let page: Int
    @State var timer : Timer? = nil
    @State var currentMessage : Message = Message(time: 1, sender: "", text: "")
    init(messagesID: UUID, pageBinding: Binding<Int>, page: Int, scrollTo: Binding<UUID>, triggerScroll: Binding<Bool>, bottomCardOpen: Binding<Bool>, bottomCardReaction: Binding<Reaction>, showLoading: Binding<Bool>){
        self.messagesID = messagesID
        self._pageBinding = pageBinding
        self._scrollTo = scrollTo
        self._triggerScroll = triggerScroll
        self._bottomCardOpen = bottomCardOpen
        self._bottomCardReaction = bottomCardReaction
        self._showLoading = showLoading
        self.page = page
        var fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(\Message.time, order: .reverse)])
        fetchDescriptor.fetchLimit = showLoading.wrappedValue ? 70 : .none
        fetchDescriptor.fetchOffset = page > 2 ? (page - 2) * 30 : 0
        fetchDescriptor.predicate = #Predicate{
            $0.chatMessagesID == messagesID
        }
        _messages = Query(fetchDescriptor)
    }
   
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{proxy in
                    LazyVStack(spacing: 8){
                        if showLoading{
                            ProgressView()
                                .onAppear(){
                                    pageBinding += 1
                                }
                        }
                        ForEach(messages.sorted(by: {$0.time < $1.time})) {message in
                            if message.sender == "me" {
                                MeMSG(
                                    message: message,
                                    pos: "top",
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    triggerScroll: $triggerScroll,
                                    showTime: showTime,
                                    glowOriginMessage: $glowOriginMessage
                                )
                                .onAppear(){
                                    currentMessage = message
                                }
                                .id(message.id)
                                .onTapGesture(){
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
                            }
                            else{
                                YouMSG(
                                    message: message,
                                    pos: "top",
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    triggerScroll: $triggerScroll,
                                    showTime: showTime,
                                    glowOriginMessage: $glowOriginMessage
                                )
                                .onAppear(){
                                    currentMessage = message
                                }
                                .id(message.id)
                                .onTapGesture(){
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
                            }
                        }
                        if page > 1 {
                            ProgressView()
                                .onAppear(){
                                    pageBinding -= 1
                                }
                        }
                    }
                    .onChange(of: triggerScroll){
                        proxy.scrollTo(scrollTo)
                    }
                }
            }
            VStack{
                HStack{
                    Text(DateHandler.formatDate(currentMessage.time, lang: "de_DE"))
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
        .padding(.horizontal, 10)
        .defaultScrollAnchor(.bottom)
        .padding(.top, 1)
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
    }
}

import SwiftUI

extension Dictionary where Value: Equatable{
    func keys(forValue value: Value)-> [Key]{
        return compactMap{ (key, element) in
            return element == value ? key : nil
            
        }
    }
}

struct Chat: Identifiable, Equatable, Hashable{
    let id: UUID = UUID()
    var title: String
    var participants: [String]
    var messages: [Message] = []
}

struct Message: Identifiable, Equatable, Hashable{
    var time: String
    var sender: String
    var type: String = "normal"
    var reply: Reply = Reply(originID: testMessageUUID, text: "", sender: "")
    let attachments: [Attachment] = []
    var text: String
    var reactions: [String: String] = [:]
    var background: String = "normal"
    var id: UUID = UUID()
}

struct Attachment: Equatable, Hashable{
    let type: String
    let dataPath: String
}

struct Reaction{
    var mostUsed: String
    var countString: String
    var emojisCount: [String: Int]
    var differentEmojisCount: Int
    var peopleReactions: [String: String]
}

struct Reply: Equatable, Hashable{
    var originID: UUID
    var text: String
    var sender: String
}

struct FormattedChar{
    let char: String
    let formats: [String]
}
let testMessageUUID: UUID = UUID()

let defaultMessages: [Message] = [Message(time: "01.01.2024 17:23", sender: "me", text: "Gute Nacht", reactions: ["me": "🙃", "you": "😆"]), Message(time: "02.01.2024 11:28", sender: "me", text: "Hey, hast du grad Zeit? Wir wollten mal noch unser Wochende planen 😅"), Message(time: "02.01.2024 11:29", sender: "you", text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", id: testMessageUUID), Message(time: "02.01.2024 11:30", sender: "you", text: "So habe ich geschaut. Es klappt. Hast du die anderen schon gefragt?"), Message(time: "02.01.2024 11:30", sender: "me", text: "Ja, die haben alle Zeit"), Message(time: "02.01.2024 11:30", sender: "me", text: "womit wollen wir anfangen?"), Message(time: "02.01.2024 11:31", sender: "you", text: "Ich würde vorschlagen das wir erstmal in ein schönes Restaurant gehen. Ich hätte das La Casa im Blick."), Message(time: "02.01.2024 11:32", sender: "me", text: "gibt es da auch was veganes auf der Speisekarte?"), Message(time: "02.01.2024 11:33", sender: "you", text: "Das", reactions: ["me": "🙃", "you": "😆"]), Message(time: "02.01.2024 11:33", sender: "you", text: "Oder war es doch Tom ?"), Message(time: "02.01.2024 11:34", sender: "you", text: "Ich bringe das grade etwas durcheinander. Vielleicht kannst du nochmal nachfragen. Du hast die Nummern von denen."), Message(time: "02.01.2024 11:35", sender: "me", text: "Anna war es. Sie verträgt kein Gluten"), Message(time: "02.01.2024 11:35", sender: "me", text: "Gut dass du dran denkst"), Message(time: "02.01.2024 11:35", sender: "me", text: "hatte ich grade garnicht auf dem schirm"), Message(time: "02.01.2024 11:36", sender: "you", text: "Perfekt, dann rufe ich dort später mal an. Soll ich noch jemanden abholen ? Und, wenn ja könntest du mir die Adressen weiterleiten ? Würde sich anbieten da sie auf dem Weg liegen und dann müssen wir nicht mit so vielen Autos fahren."), Message(time: "02.01.2024 11:38", sender: "me", text: "Ja, mich und Luca wäre super. Meine Addresse kennst du ja, Luca wohnt im Randomweg 787"), Message(time: "02.01.2024 11:39", sender: "you", text: "Alles klar. Habe ich dann jetzt direkt im Navi abgespeichert. Passt es dann Luca, wenn ich ihn als erstes abhole?"), Message(time: "02.01.2024 11:40", sender: "me", text: "Ja klar"), Message(time: "02.01.2024 11:40", sender: "you", text: "Wäre dann so um ca 18 Uhr vor seiner Haustür."), Message(time: "02.01.2024 11:40", sender: "me", text: "super, gebe ich weiter"), Message(time: "02.01.2024 11:40", sender: "me", text: "Er freut sich"), Message(time: "02.01.2024 11:41", sender: "you", text: "Perfekt, ich mich auch. Sollte noch was sein melde dich einfach."), Message(time: "02.01.2024 11:42", sender: "me", type: "reply", reply: Reply(originID: testMessageUUID, text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", sender: "You"), text: "Mach ich, bis dann"), Message(time: "06.01.2024 19:44", sender: "me", text: "Hallo~ ich _bin *Mia_ lol* ~Test _123_~")]

struct ContentView: View {
    @State var chats: [Chat] = [Chat(title: "Eli", participants: ["you", "me"], messages: defaultMessages)]
    
    var body: some View {
        ChatViewTest(messages: $chats[0].messages)
    }
}

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
                                MeMSG(message: $messages[index], pos: index-1 < 0 || messages[index-1].sender != messages[index].sender || messages[index - 1].time.split(separator: " ")[0] !=  messages[index].time.split(separator: " ")[0]  ? "top" : "bottom", nextTime: index + 1 < messages.count && messages[index+1].sender == messages[index].sender ? messages[index + 1].time : nil, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
                                    .padding(.top, index - 1 >= 0 && messages[index].sender != messages[index-1].sender ? 4 : 0)
                                    .id(messages[index].id)
                            }
                            else{
                                YouMSG(message: $messages[index], pos: index-1 < 0 || messages[index-1].sender == "me" ? "top" : "bottom", nextTime: index + 1 < messages.count && messages[index+1].sender == messages[index].sender ? messages[index + 1].time : nil, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
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

struct MeMSG: View{
    @Binding var message: Message
    let pos: String
    let nextTime: String?
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction
    @State var reactionContainer = ""
    @State var reactionCount: Float = 0
    @State var msgWidth = 0.0
    @State var reactionWidth = 0.0
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var scrollTo: UUID
    @Binding var messages: [Message]
    @Binding var triggerScroll: Bool
    @State var formattedChars: [FormattedChar] = []
    var body: some View{
        VStack{
            HStack{
                Spacer(minLength: UIScreen.main.bounds.width*0.16)
                ZStack(alignment: .bottomTrailing){
                    VStack(alignment: .leading){
                        if message.type == "reply"{
                            HStack{
                                ZStack(alignment: .leading){
                                    Text(message.text)
                                        .frame(maxHeight: 5)
                                        .hidden()
                                    AnswerDisplay(text: message.reply.text, senderName: message.reply.sender, originMessageID: message.reply.originID)
                                }
                            }
                            .onTapGesture {
                                scrollTo = message.reply.originID
                                triggerScroll.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                    withAnimation(.easeIn){
                                        messages[messages.firstIndex(where:{$0.id == message.reply.originID})!].background = "glow"
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                                        withAnimation(.easeIn){
                                            messages[messages.firstIndex(where:{$0.id == message.reply.originID})!].background = "normal"
                                        }
                                    }
                                }
                            }
                            .background{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray)
                                    .opacity(0.5)
                            }
                        }
                        if !reactionContainer.isEmpty{
                            if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                Text(message.text)
                                    .padding(.bottom, 14.5)
                            }
                            else{
                                formatText()
                                    .padding(.bottom, 14.5)
                                    .onAppear(){
                                        formattedChars = formatChars(message.text)
                                    }
                            }
                        }
                        else{
                            if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                Text(message.text)
                            }
                            else{
                                formatText()
                                    .onAppear(){
                                        formattedChars = formatChars(message.text)
                                    }
                            }
                        }
                    }
                    .padding(10)
    
                    Text(reactionContainer)
                        .font(.custom("JetBrainsMono-Regular", size: 13))
                        .padding([.bottom,.trailing,.top] , 2.5)
                        .padding(.leading, 4)
                        .background(){
                            UnevenRoundedRectangle
                                .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 10, bottomTrailing: 5, topTrailing: 5))
                                .fill(Color.init("ReactionDisplay"))
                        }
                        .hidden()
                    
                }
                .background(
                    UnevenRoundedRectangle
                        .rect(
                            cornerRadii: RectangleCornerRadii(topLeading: 10, bottomLeading: 10, bottomTrailing: 2, topTrailing: pos == "bottom" ? 2 : 10)
                        )
                        .fill(message.background == "normal" ? Color.init("MeMSG") : .gray)
                )
                .overlay(alignment: .bottomLeading, content: {
                    if !reactionContainer.isEmpty && Double(reactionContainer.count) * 1.2 <= Double(message.text.count){
                        Text(reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 10, bottomTrailing: 5, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                    else if !reactionContainer.isEmpty{
                        Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 10, bottomTrailing: 5, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                })
            }
            
            HStack{
                if nextTime != message.time {
                    Spacer()
                    Text(message.time.split(separator: " ")[1])
                        .font(Font.custom("JetBrainsMono-Regular", size: 10))
                        .frame(alignment: .bottomTrailing)
                        .opacity(0.75)
                }
            }
            .onAppear{
                reactionData = genReactions()
                reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
            }
            .onChange(of: message){
                reactionData = genReactions()
                reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
            }
        }
        .contextMenu{
            Button(role: .destructive){
            } label: {
                Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
            }
        }
    }
    func formatText()-> some View{
        var text = Text("")
        for i in 0..<formattedChars.count{
            if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic().strikethrough()
            }
            else if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && !formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic()
            }
            else if formattedChars[i].formats.contains("*") && !formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).strikethrough()
            }
            else if formattedChars[i].formats == ["*"] {
                text = text+Text(formattedChars[i].char).fontWeight(.bold)
            }
            else if !formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).italic().strikethrough()
            }
            else if formattedChars[i].formats == ["_"] {
                text = text+Text(formattedChars[i].char).italic()
            }
            else if formattedChars[i].formats == ["~"] {
                text = text+Text(formattedChars[i].char).strikethrough()
            }
            else{
                text = text + Text(formattedChars[i].char)
            }
        }
        return text
    }
    
    func formatChars(_ str: String) -> [FormattedChar] {
        var formattedChars: [FormattedChar] = []
        var currentChar = ""
        var previousChar = ""
        var currentFormats: [String] = []
        var blockAdding = false
        let input = str.replacingOccurrences(of: "\n", with: "￿")
        
        let allowedSurroundingChars = ["", " ", "￿", ".", ",", ":", ";", "\"", "'", "*", "_", "~"]
        for i in 0..<input.count {
            let atm =  String(input[input.index(input.startIndex, offsetBy: i)])
            
            let next = i + 1 < input.count ? String(input[input.index(input.startIndex, offsetBy: i+1)]) : ""
            if (atm == "*" || atm == "_" || atm == "~") && (allowedSurroundingChars.contains(previousChar) || allowedSurroundingChars.contains(next))  {
                    
                if !currentChar.isEmpty {
                    let formattedChar = FormattedChar(char: currentChar, formats: currentFormats)
                    formattedChars.append(formattedChar)
                    currentChar = ""
                    
                }
                if currentFormats.contains(String(atm)) && allowedSurroundingChars.contains(next){
                    currentFormats.removeAll(where: {$0 == String(atm)})
                    blockAdding = true
                }
                if !blockAdding && allowedSurroundingChars.contains(previousChar) {
                    currentFormats.append(String(atm))
                }
                else{
                    blockAdding = false
                }
            } else {
                currentChar.append(atm)
            }
            previousChar = atm
            
        }
        if !currentChar.isEmpty {
            let formattedChar = FormattedChar(char: currentChar.replacingOccurrences(of: "￿", with: "\n"), formats: currentFormats)
            formattedChars.append(formattedChar)
        }
        
        
        return formattedChars
    }
    func genReactions()-> Reaction{
        let differentEmojis = Array(Set(message.reactions.values))
        var emojisCount: [String : Int] = [:]
        var totalCount = 0.0
        var reactionCache = ""
        let differentEmojisCount = differentEmojis.count
        for i in 0 ..< differentEmojis.count{
            let countForEmoji = message.reactions.keys(forValue: differentEmojis[i]).count
            emojisCount[differentEmojis[i]] = countForEmoji
            totalCount += Double(countForEmoji)
        }
        let sortedByCount = Dictionary(uniqueKeysWithValues: emojisCount.sorted(by: {$0.value > $1.value}))
        let reactionList = Array(sortedByCount.keys)
        for i in 0 ..< sortedByCount.count {
            if (i < 4){
                reactionCache += reactionList[i]
            }
        }
        var countString = String(Int(totalCount))
        if totalCount > 1000{
            totalCount = totalCount / 1000
            totalCount = (totalCount*10).rounded()/10
            countString = String(totalCount)+"K"
        }
        return Reaction(mostUsed: reactionCache, countString: countString, emojisCount: emojisCount, differentEmojisCount: differentEmojisCount, peopleReactions: message.reactions)
    }
}

struct YouMSG: View{
    @Binding var message: Message
    let pos: String
    let nextTime: String?
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction
    @State var reactionContainer = ""
    @State var reactionCount: Float = 0
    @State var msgWidth = 0.0
    @State var reactionWidth = 0.0
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var scrollTo: UUID
    @Binding var messages: [Message]
    @Binding var triggerScroll: Bool
    @State var formattedChars: [FormattedChar] = []
    var body: some View{
        VStack{
            HStack{
                ZStack(alignment: .bottomLeading){
                    VStack(){
                        if message.type == "reply"{
                            HStack{
                                ZStack(alignment: .leading){
                                    Text(message.text)
                                        .frame(maxHeight: 5)
                                        .hidden()
                                    AnswerDisplay(text: message.reply.text, senderName: message.reply.sender, originMessageID: message.reply.originID)
                                }
                            }
                            .onTapGesture {
                                scrollTo = message.reply.originID
                                triggerScroll.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                    withAnimation(.easeIn){
                                        messages[messages.firstIndex(where:{$0.id == message.reply.originID})!].background = "glow"
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                                        withAnimation(.easeIn){
                                            messages[messages.firstIndex(where:{$0.id == message.reply.originID})!].background = "normal"
                                        }
                                    }
                                }
                            }
                            .background{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray)
                                    .opacity(0.5)
                            }
                        }
                        if !reactionContainer.isEmpty{
                            if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                Text(message.text)
                                    .padding(.bottom, 14.5)
                            }
                            else{
                                formatText()
                                    .padding(.bottom, 14.5)
                                    .onAppear(){
                                        formattedChars = formatChars(message.text)
                                    }
                            }
                        }
                        else{
                            if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                Text(message.text)
                            }
                            else{
                                formatText()
                                    .onAppear(){
                                        formattedChars = formatChars(message.text)
                                    }
                            }
                        }
                    }
                    .padding(10)
    
                    Text(reactionContainer)
                        .font(.custom("JetBrainsMono-Regular", size: 13))
                        .padding([.bottom,.leading,.top] , 2.5)
                        .padding(.trailing, 4)
                        .background(){
                            UnevenRoundedRectangle
                                .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 5, bottomTrailing: 10, topTrailing: 5))
                                .fill(Color.init("ReactionDisplay"))
                        }
                        .hidden()
                    
                }
                .background(
                    UnevenRoundedRectangle
                        .rect(
                            cornerRadii: RectangleCornerRadii(topLeading: pos == "bottom" ? 2 : 10, bottomLeading: 2, bottomTrailing: 10, topTrailing: 10)
                        )
                        .fill(message.background == "normal" ? Color.init("YouMSG") : .gray)
                )
                .overlay(alignment: .bottomTrailing, content: {
                    if !reactionContainer.isEmpty && Double(reactionContainer.count) * 1.2 <= Double(message.text.count){
                        Text(reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 5, bottomTrailing: 10, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                    else if !reactionContainer.isEmpty{
                        Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 5, bottomTrailing: 10, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                })
                Spacer(minLength: UIScreen.main.bounds.width*0.16)
            }
            
            
            HStack{
                if nextTime != message.time {
                    Text(message.time.split(separator: " ")[1])
                        .font(Font.custom("JetBrainsMono-Regular", size: 10))
                        .frame(alignment: .bottomTrailing)
                        .opacity(0.75)
                }
                Spacer()
            }
            .onAppear{
                reactionData = genReactions()
                reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
            }
            .onChange(of: message){
                reactionData = genReactions()
                reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
            }
        }
        .contextMenu{
            Button(role: .destructive){
                messages.removeAll(where: {$0.id == message.id})
            } label: {
                Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
            }
        }
    }
    func formatText()-> some View{
        var text = Text("")
        for i in 0..<formattedChars.count{
            if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic().strikethrough()
            }
            else if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && !formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic()
            }
            else if formattedChars[i].formats.contains("*") && !formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).strikethrough()
            }
            else if formattedChars[i].formats == ["*"] {
                text = text+Text(formattedChars[i].char).fontWeight(.bold)
            }
            else if !formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).italic().strikethrough()
            }
            else if formattedChars[i].formats == ["_"] {
                text = text+Text(formattedChars[i].char).italic()
            }
            else if formattedChars[i].formats == ["~"] {
                text = text+Text(formattedChars[i].char).strikethrough()
            }
            else{
                text = text + Text(formattedChars[i].char)
            }
        }
        return text
    }
    
    func formatChars(_ str: String) -> [FormattedChar] {
        var formattedChars: [FormattedChar] = []
        var currentChar = ""
        var previousChar = ""
        var currentFormats: [String] = []
        var blockAdding = false
        let input = str.replacingOccurrences(of: "\n", with: "￿")
        
        let allowedSurroundingChars = ["", " ", "￿", ".", ",", ":", ";", "\"", "'", "*", "_", "~"]
        for i in 0..<input.count {
            let atm =  String(input[input.index(input.startIndex, offsetBy: i)])
            
            let next = i + 1 < input.count ? String(input[input.index(input.startIndex, offsetBy: i+1)]) : ""
            if (atm == "*" || atm == "_" || atm == "~") && (allowedSurroundingChars.contains(previousChar) || allowedSurroundingChars.contains(next))  {
                    
                if !currentChar.isEmpty {
                    let formattedChar = FormattedChar(char: currentChar, formats: currentFormats)
                    formattedChars.append(formattedChar)
                    currentChar = ""
                    
                }
                if currentFormats.contains(String(atm)) && allowedSurroundingChars.contains(next){
                    currentFormats.removeAll(where: {$0 == String(atm)})
                    blockAdding = true
                }
                if !blockAdding && allowedSurroundingChars.contains(previousChar) {
                    currentFormats.append(String(atm))
                }
                else{
                    blockAdding = false
                }
            } else {
                currentChar.append(atm)
            }
            previousChar = atm
            
        }
        if !currentChar.isEmpty {
            let formattedChar = FormattedChar(char: currentChar.replacingOccurrences(of: "￿", with: "\n"), formats: currentFormats)
            formattedChars.append(formattedChar)
        }
        
        
        return formattedChars
    }
    func genReactions()-> Reaction{
        let differentEmojis = Array(Set(message.reactions.values))
        var emojisCount: [String : Int] = [:]
        var totalCount = 0.0
        var reactionCache = ""
        let differentEmojisCount = differentEmojis.count
        for i in 0 ..< differentEmojis.count{
            let countForEmoji = message.reactions.keys(forValue: differentEmojis[i]).count
            emojisCount[differentEmojis[i]] = countForEmoji
            totalCount += Double(countForEmoji)
        }
        let sortedByCount = Dictionary(uniqueKeysWithValues: emojisCount.sorted(by: {$0.value > $1.value}))
        let reactionList = Array(sortedByCount.keys)
        for i in 0 ..< sortedByCount.count {
            if (i < 4){
                reactionCache += reactionList[i]
            }
        }
        var countString = String(Int(totalCount))
        if totalCount > 1000{
            totalCount = totalCount / 1000
            totalCount = (totalCount*10).rounded()/10
            countString = String(totalCount)+"K"
        }
        return Reaction(mostUsed: reactionCache, countString: countString, emojisCount: emojisCount, differentEmojisCount: differentEmojisCount, peopleReactions: message.reactions)
    }
}


struct BottomCard<Content: View>: View {
    @ViewBuilder let content: Content
    @Binding var isOpen: Bool
    
    @State var totalHeight: Double = 0
    
    @State var startHeight = 0.0
    @State var blockActualisation = false
    
    let maxHeight = UIScreen.main.bounds.height * 0.8
    let normalHeight = UIScreen.main.bounds.height * 0.5
    let fullOpenHeight = UIScreen.main.bounds.height * 0.6
    let toNormalHeight = UIScreen.main.bounds.height * 0.7
    let closeHeight = UIScreen.main.bounds.height * 0.3
    
    var body: some View {
        VStack{
            HStack{
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 100, height: 5)
                    .padding(15)
            }
            .background(Color.init("BottomCardBackground"))
            .gesture(
                DragGesture()
                    .onChanged{value in
                        if !blockActualisation{
                            startHeight = totalHeight
                            blockActualisation = true
                        }
                        let newHeight = self.totalHeight - value.translation.height
                        totalHeight = max(100, min(newHeight, maxHeight))
                    }
                    .onEnded{_ in
                        blockActualisation = false
                        if totalHeight < closeHeight{
                            withAnimation(.easeOut(duration: 0.2)){
                                totalHeight = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                isOpen = false
                            }
                        }
                        else if startHeight == maxHeight{
                            if totalHeight < toNormalHeight {
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = normalHeight
                                }
                            }
                            else{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = maxHeight
                                }
                            }
                        }
                        else if startHeight == normalHeight{
                            if totalHeight > fullOpenHeight{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = maxHeight
                                }
                            }
                            else if totalHeight > normalHeight && totalHeight <= fullOpenHeight{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = normalHeight
                                }
                            }
                            else if totalHeight >= closeHeight{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = normalHeight
                                }
                            }
                        }
                        
                    }
            )
            
            ScrollView{
                content
            }
        }
        .onAppear(){
            withAnimation(.easeIn(duration: 0.3)){
                totalHeight = UIScreen.main.bounds.height * 0.5
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: totalHeight)
        .background{
            UnevenRoundedRectangle
                .rect(cornerRadii: RectangleCornerRadii(topLeading: 25, topTrailing: 25))
                .fill(Color.init("BottomCardBackground"))
        }
        .onChange(of: isOpen){
            if isOpen{
                totalHeight = 0
                withAnimation(.easeIn(duration: 0.5)){
                    totalHeight = UIScreen.main.bounds.height * 0.5
                }
            }
            else{
                withAnimation(.easeOut(duration: 0.5)){
                    totalHeight = 0
                }
            }
        }
    }
}

struct ReactionOverview: View {
    @State var showView: String = "overview"
    @Binding var reaction: Reaction
    @State var emojis: [String]
    @State var buttonTapped: [String: Bool] = [:]
    var body: some View {
        if showView == "overview"{
            VStack{
                ForEach(0..<emojis.count){index in
                    HStack{
                        Text(emojis[index])
                        Spacer()
                        Text(String(reaction.emojisCount[emojis[index]] ?? 0))
                            .font(.custom("JetBrainsMono-Regular", size: 16))
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.init(buttonTapped[emojis[index]] ?? false ? "BottomCardButtonClicked" : "BottomCardBackground"))
                    }
                    .onTapGesture {
                        buttonTapped[emojis[index]] = true
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            showView = emojis[index]
                        }
                    }
                    if index+1 != emojis.count{
                        Divider()
                    }
                }
            }
            .padding(15)
            .onAppear(){
                for i in 0..<emojis.count{
                    buttonTapped[emojis[i]] = false
                }
            }
        }
        else if showView != ""{
            SpecificReaction(relevantUsers: reaction.peopleReactions.keys(forValue: showView), showView: $showView)
        }
    }
}

struct SpecificReaction: View {
    @State var relevantUsers: [String]
    @Binding var showView: String
    var body: some View {
        VStack{
            Button{
                showView = "overview"
            } label: {
                Label("", systemImage: "arrowshape.backward")
            }
            VStack{
                ForEach(0..<relevantUsers.count){index in
                    Text(relevantUsers[index])
                    if index+1 != relevantUsers.count{
                        Divider()
                    }
                }
            }
        }
    }
}

struct AnswerDisplay: View {
    @State var text: String
    @State var senderName: String
    @State var originMessageID: UUID
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text(senderName)
                .bold()
                .font(.system(size: 14))
            Text(text.count > 150 ? "\(text.prefix(150).prefix(upTo: text.prefix(150).lastIndex(of: " ") ?? text.prefix(150).endIndex))..." : text)
                .font(.system(size: 12))
        }
        .padding(3)
    }
}


struct ChatViewTest: View {
    @State var bottomCardOpen = false
    @State var bottomCardReaction: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @State var scrollTo = UUID()
    @Binding var messages: [Message]
    @State var triggerScroll = false
    @State var msg = Message(time: "", sender: "", text: "")
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{proxy in
                    LazyVStack(spacing: 8){
                        if messages.count > 0{
                            HStack{
                                Spacer()
                                Text(messages[0].time.split(separator: " ")[0])
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
                        ForEach($messages, id: \.id){ message in
                            if message.sender.wrappedValue == "me" {
                                MeMSG(message: message, pos: "", nextTime: "", bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
                                    .padding(4)
                            }
                            else{
                                YouMSG(message: message, pos: "", nextTime: "", bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
                                    .padding(.top, 4)
                                    .id(message.id)
                            }
                            if true{
                                HStack{
                                    Spacer()
                                    Text(message.time.split(separator: " ")[0])
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
}

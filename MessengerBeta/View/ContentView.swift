import SwiftUI
import SwiftData

extension Dictionary where Value: Equatable{
    func keys(forValue value: Value)-> [Key]{
        return compactMap{ (key, element) in
            return element == value ? key : nil
            
        }
    }
}

let testMessageUUID: UUID = UUID()

let testChatUUID: UUID = UUID()

let testMessagesUUID: UUID = UUID()

struct ContentView: View{
    @Query var chats: [Chat]
    //@Query var msgs: [Message]
    @Environment(\.modelContext) var context
    @State var page: Int = 1
    @State var scrollTo: UUID? = UUID()
    @State var triggerScroll = false
    @State var showLoading: Bool = false
    @State var bottomCardOpen = false
    @State var bottomCardReaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 1, peopleReactions: [:])
    @State var messageInput: String = ""
    
    var body: some View {
        ZStack{
            if !chats.isEmpty{
                VStack{
                    GeometryReader{geometry in
                        ChatView(messagesID: chats.first!.messagesID, pageBinding: $page, page: page, scrollTo: $scrollTo, triggerScroll: $triggerScroll, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, showLoading: $showLoading)
                            .ignoresSafeArea(.keyboard)
                            .onChange(of: page){
                                do{
                                    let messagesID = chats.first!.messagesID
                                    let count = try context.fetchCount(FetchDescriptor<Message>(predicate: #Predicate{
                                        $0.chatMessagesID == messagesID
                                    }))
                                    if count > page * 30 + 70{
                                        showLoading = true
                                    }
                                    else{
                                        showLoading = false
                                    }
                                }
                                catch{
                                    showLoading = false
                                }
                            }
                            .onAppear(){
                                do{
                                    let messagesID = chats.first!.messagesID
                                    let count = try context.fetchCount(FetchDescriptor<Message>(predicate:  #Predicate{
                                        $0.chatMessagesID == messagesID
                                    }))
                                    if count > page * 30 + 70{
                                        showLoading = true
                                    }
                                    else{
                                        showLoading = false
                                    }
                                }
                                catch{
                                    showLoading = false
                                }
                            }
                    }
                    HStack{
                        Button(){
                            
                        }label: {
                            Image(systemName: "plus")
                        }
                        .padding(.horizontal, 5)
                        TextField(LocalizedStringKey(""), text: $messageInput, axis: .vertical)
                            .gesture(DragGesture(minimumDistance: 15))
                            .padding(5)
                            .lineLimit(3)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).fill(Color.gray))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 4)
                        
                        Button(){
                            
                        }label: {
                            Image(systemName: "paperplane")
                        }
                        .padding(.horizontal, 5)
                    }
                    .padding(.horizontal, 10)
                }
            }
            else{
                Text("renderfehler")
                    .onAppear(){
                        if chats.isEmpty{
                            for chat in chats {
                                context.delete(chat)
                            }
                            for defaultMessage in defaultMessages {
                                context.insert(defaultMessage)
                            }
                            context.insert(defaultChat)
                        }
                    }
            }
            if(bottomCardOpen){
                BottomCard(content: {ReactionOverview(reaction: $bottomCardReaction, emojis: Array(bottomCardReaction.emojisCount.keys))}, isOpen: $bottomCardOpen)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
    func hideKeyboard()->Void{
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


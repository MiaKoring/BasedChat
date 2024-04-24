import SwiftUI
import SwiftData

let testMessageUUID: UUID = UUID()

let testChatUUID: UUID = UUID()

let testMessagesUUID: UUID = UUID()

struct ChatView: View{
    @Query var chats: [Chat]
    @Environment(\.modelContext) var context
    @State var scrollTo: UUID? = UUID()
    @State var triggerScroll = false
    @State var showLoading: Bool = false
    @State var bottomCardOpen = false
    @State var bottomCardReaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 1, peopleReactions: [:])
    @State var messageInput: String = ""
    @State private var keyboardShown: Bool = false
    @State var replyTo: Reply? = nil
    @State var textFieldFocused: Bool = false
    @State var showMessageEmptyAlert = false
    @State var newMessageSent = false
    
    var body: some View {
        if !chats.isEmpty{
            ZStack(alignment: .bottom){
                VStack{
                    //MessageView(messagesID: chats.first!.messagesID, scrollTo: $scrollTo, triggerScroll: $triggerScroll, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, showLoading: $showLoading, replyTo: $replyTo, newMessageSent: $newMessageSent)
                        //.padding(.top, 40)
                    if replyTo != nil{
                        HStack{
                            ReplyToDisplay(replyTo: $replyTo)
                                .frame(height: 50)
                            Spacer()
                            Button{
                                replyTo = nil
                            } label: {
                                Image(systemName: "xmark.circle")
                            }
                        }
                        .background(Color.init("BottomCardButtonClicked"))
                    }
                    Spacer()
                    HStack{
                        Button{
                            if messageInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                                showMessageEmptyAlert = true
                                return
                            }
                            var msg: Message? = nil
                            if replyTo == nil{
                                msg = Message(chatMessagesID: chats.first!.messagesID, time: Int(Date().timeIntervalSince1970), sender: 2, text: messageInput, messageID: 1010, isRead: false)
                            }
                            else{
                                msg = Message(chatMessagesID: chats.first!.messagesID, time: Int(Date().timeIntervalSince1970), sender: 2, type: "reply", reply: replyTo!, text: messageInput, messageID: 1010, isRead: false)
                                replyTo = nil
                            }
                            context.insert(msg!)
                            newMessageSent.toggle()
                            messageInput = ""
                            hideKeyboard()
                        }label: {
                            Image(systemName: "plus")
                        }
                        TextField(LocalizedStringKey("Message"), text: $messageInput, axis: .vertical)
                            .padding(5)
                            .lineLimit(3)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).fill(Color.gray))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 4)
                        
                        Button{
                            if messageInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                                showMessageEmptyAlert = true
                                return
                            }
                            var msg: Message? = nil
                            if replyTo == nil{
                                msg = Message(chatMessagesID: chats.first!.messagesID, time: Int(Date().timeIntervalSince1970), sender: 1, text: messageInput, messageID: 1020)
                            }
                            else{
                                msg = Message(chatMessagesID: chats.first!.messagesID, time: Int(Date().timeIntervalSince1970), sender: 1, type: "reply", reply: replyTo!, text: messageInput, messageID: 1020)
                                replyTo = nil
                            }
                            context.insert(msg!)
                            newMessageSent.toggle()
                            messageInput = ""
                            hideKeyboard()
                        } label: {
                            Image(systemName: "paperplane")
                        }
                        .alert(LocalizedStringKey("EmptyMessageAlert"), isPresented: $showMessageEmptyAlert){
                            Button("OK", role: .cancel){}
                        }
                    }
                }
                .padding(.bottom, keyboardShown ? 0 : UIApplication.shared.windows.first!.safeAreaInsets.bottom)
                if(bottomCardOpen){
                    BottomCard(content: {ReactionOverview(reaction: $bottomCardReaction, emojis: Array(bottomCardReaction.emojisCount.keys))}, isOpen: $bottomCardOpen)
                        .ignoresSafeArea(.container)
                }
            }
            .ignoresSafeArea(.container)
            .onAppear(){
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    self.keyboardShown = true
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    self.keyboardShown = false
                }
            }
        }
        else{
            Text("creating test data")
                .onAppear(){
                   /* for message in defaultMessages{
                        context.insert(message)
                    }
                    context.insert(defaultChat)*/
                }
        }
    }
    func hideKeyboard()->Void{
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

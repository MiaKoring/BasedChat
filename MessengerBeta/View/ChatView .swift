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


/*struct ChatView: View{
    @Query var chats: [Chat]
    @Environment(\.modelContext) var context
    @State var page: Int = 1
    @State var scrollTo: UUID? = UUID()
    @State var triggerScroll = false
    @State var showLoading: Bool = false
    @State var bottomCardOpen = false
    @State var bottomCardReaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 1, peopleReactions: [:])
    @State var messageInput: String = ""
    @State private var keyboardHeight: CGFloat = 0
    @State var replyTo: Reply? = nil
    @FocusState var textFieldFocused
    @State var inputHeight = 0.0
    
    var body: some View {
        ZStack{
            MessageView(messagesID: chats.first!.messagesID, pageBinding: $page, page: page, scrollTo: $scrollTo, triggerScroll: $triggerScroll, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, showLoading: $showLoading, replyTo: $replyTo)
                .offset(x: 0, y: min(-keyboardHeight - inputHeight + UIApplication.shared.windows.first!.safeAreaInsets.bottom, 0 - inputHeight))
                .ignoresSafeArea(.keyboard)
            VStack{
                Spacer()
                VStack{
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
                    HStack{
                        Image(systemName: "plus")
                        TextField(LocalizedStringKey("Message"), text: $messageInput, axis: .vertical)
                            .padding(5)
                            .lineLimit(3)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).fill(Color.gray))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 4)
                            .focused($textFieldFocused)
                            .onChange(of: replyTo){
                                if replyTo != nil{
                                    textFieldFocused = true
                                }
                                print("replyTo changed")
                            }
                        Button{
                            
                        } label: {
                            Image(systemName: "paperplane")
                        }
                    }
                    
                }
                .ignoresSafeArea(.keyboard)
                .offset(x: 0, y: min(-keyboardHeight + UIApplication.shared.windows.first!.safeAreaInsets.bottom, 0))
                .background(){
                    GeometryReader{geometry in
                        Rectangle()
                            .hidden()
                            .onAppear(){
                                inputHeight = geometry.size.height
                            }
                            .onChange(of: geometry.size.height){
                                print("geometryHeight Changed")
                                inputHeight = geometry.size.height
                            }
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
            if(bottomCardOpen){
                BottomCard(content: {ReactionOverview(reaction: $bottomCardReaction, emojis: Array(bottomCardReaction.emojisCount.keys))}, isOpen: $bottomCardOpen)
            }

        }
        .onAppear(){
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = keyboardFrame.height
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }
    }
    func hideKeyboard()->Void{
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
*/

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
    
    var body: some View {
        if !chats.isEmpty{
            ZStack(alignment: .bottom){
                VStack{
                    MessageView(messagesID: chats.first!.messagesID, scrollTo: $scrollTo, triggerScroll: $triggerScroll, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, showLoading: $showLoading, replyTo: $replyTo)
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
                        Image(systemName: "plus")
                        TextField(LocalizedStringKey("Message"), text: $messageInput, axis: .vertical)
                            .padding(5)
                            .lineLimit(3)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).fill(Color.gray))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 4)
                        
                        Button{
                            
                        } label: {
                            Image(systemName: "paperplane")
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
                    for message in defaultMessages{
                        context.insert(message)
                    }
                    context.insert(defaultChat)
                }
        }
    }
    func hideKeyboard()->Void{
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

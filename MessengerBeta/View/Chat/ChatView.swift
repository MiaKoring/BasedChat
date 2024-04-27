import SwiftUI
import SwiftData

struct ChatView: View {
    //MARK: - Body
    
    var body: some View {
        VStack{
            MessageScrollView(messages: chat.messages.sorted(by: {$0.messageID < $1.messageID}), bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, replyTo: $replyTo, newMessageSent: $newMessageSent, messageToDelete: $messageToDelete, keyboardShown: $keyboardShown)
            if replyTo != nil{
                HStack{
                    ReplyToDisplayView(replyTo: $replyTo)
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
            ChatInputView(replyTo: $replyTo, newMessage: $newMessage, chat: $chat)
        }
        .padding(.horizontal, 10)
        #if canImport(UIKit)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)){_ in
                self.keyboardShown = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)){_ in
                self.keyboardShown = false
            }
        #endif
            .onChange(of: messageToDelete){
                deleteMessage()
            }
            .sheet(isPresented: $bottomCardOpen){
                VStack{
                    RoundedRectangle(cornerRadius: 25)
                        .pullbarStyle()
                    if bottomCardReaction != nil{
                        ReactionSheetView(reaction: bottomCardReaction!, selected: bottomCardReaction!.emojisCount.keys.sorted(by: {bottomCardReaction!.emojisCount[$0] ?? -1 > bottomCardReaction!.emojisCount[$1] ?? -1}).first!)
                    }
                }
                .presentationDetents([.medium])
                .presentationBackground(.ultraThickMaterial)
            }
            .onChange(of: replyTo){
                print("changed")
            }
            .onChange(of: newMessage){
                sendMessage(newMessage)
            }
            .onAppear(){
                chat.currentMessageID = max(chat.currentMessageID, 100)
            }
        
    }
    
    //MARK: - Parameters
    @State var chat: Chat
    @Environment(\.modelContext) var context
    #if canImport(UIKit)
    @Environment(\.safeAreaInsets) var safeAreaInsets
    #endif
    @State var scrollTo: UUID? = UUID()
    @State var triggerScroll = false
    @State var showLoading: Bool = false
    @State var bottomCardOpen = false
    @State var bottomCardReaction: Reaction? = nil
    @State private var keyboardShown: Bool = false
    @State var replyTo: Reply? = nil
    @State var newMessageSent = false
    @State var messageToDelete: Message? = nil
    @State var newMessage: Message? = nil
    //MARK: -
}

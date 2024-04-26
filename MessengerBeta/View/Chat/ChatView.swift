import SwiftUI
import SwiftData

struct ChatView: View {
    //MARK: - Body
    
    var body: some View {
        MessageScrollView(messages: chat.messages.sorted(by: {$0.messageID < $1.messageID}), bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, replyTo: $replyTo, messageToDelete: $messageToDelete)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)){_ in
            self.keyboardShown = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)){_ in
            self.keyboardShown = false
        }
        .onChange(of: messageToDelete){
            deleteMessage()
        }
    }
    
    //MARK: - Parameters
    var chat: Chat
    @Environment(\.modelContext) var context
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @State var scrollTo: UUID? = UUID()
    @State var triggerScroll = false
    @State var showLoading: Bool = false
    @State var bottomCardOpen = false
    @State var bottomCardReaction: Reaction?  = nil
    @State var messageInput: String = ""
    @State private var keyboardShown: Bool = false
    @State var replyTo: Reply? = nil
    @State var textFieldFocused: Bool = false
    @State var showMessageEmptyAlert = false
    @State var newMessageSent = false
    @State var messageToDelete: Message? = nil
    
    //MARK: -
}

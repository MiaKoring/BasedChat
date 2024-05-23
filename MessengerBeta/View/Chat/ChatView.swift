import SwiftUI
import SwiftData
import SlashCommands
import SwiftChameleon

struct ChatView: View {
    //MARK: - Body
    
    var body: some View {
        VStack {
            MessageScrollView(messages: chat.messages.sorted(by: {$0.messageID < $1.messageID}), showStickerDetail: $showStickerDetail, bottomCardReaction: $bottomCardReaction, replyTo: $replyTo, newMessageSent: $newMessageSent, messageToDelete: $messageToDelete, keyboardShown: $keyboardShown)
                .overlay(alignment: .bottom) {
                    VStack{
                        if currentCommand.isNil {
                            CommandList(relevantCommands: $relevantCommands, currentCommand: $currentCommand, commandInput: $messageInput)
                                .frame(height: commandListHeight())
                        }
                        CommandDetailView(commandInput: $messageInput, collection: $collection, currentCommand: $currentCommand, relevantCommands: $relevantCommands)
                    }
                    .background(.ultraThickMaterial)
                }
            if replyTo != nil {
                HStack {
                    ReplyToDisplayView(replyTo: $replyTo)
                        .frame(height: 50)
                    Spacer()
                    Button {
                        replyTo = nil
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
                .background(Color.init("BottomCardButtonClicked"))
            }
            ChatInputView(replyTo: $replyTo, messageInput: $messageInput, chat: $chat, messageSent: $messageSent, sender: $sender, sendSticker: $sendSticker, stickerPath: $stickerPath)
        }
            .padding(.horizontal, 10)
        #if canImport(UIKit)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                self.keyboardShown = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                self.keyboardShown = false
            }
        #endif
            .onChange(of: messageToDelete) {
                deleteMessage()
            }
            .sheet(isPresented: $showStickerDetail) {
                VStack {
                    RoundedRectangle(cornerRadius: 25)
                        .pullbarStyle()
                    if bottomCardReaction != nil {
                        ReactionSheetView(
                            reaction: bottomCardReaction!,
                            selected:
                                bottomCardReaction!.emojisCount.keys.sorted(by: { bottomCardReaction!.emojisCount[$0] ?? -1 > bottomCardReaction!.emojisCount[$1] ?? -1 }).first!,
                            emojisSorted:
                                bottomCardReaction!.emojisCount.keys.sorted(by: { bottomCardReaction!.emojisCount[$0] ?? -1 > bottomCardReaction!.emojisCount[$1] ?? -1 })
                        )
                    }
                }
                .presentationDetents([.medium])
                .presentationBackground(.ultraThickMaterial)
            }
            .onChange(of: messageSent) {
                handleMessageSend()
            }
            .onAppear() {
                chat.currentMessageID = max(chat.currentMessageID, 100)
                collection = CommandCollection(commands: [Bababa(completion: complete), Tableflip(completion: comp), Unflip(completion: unflipComplete)])
            }
            .onChange(of: bottomCardReaction) {} //somehow seems to fix https://github.com/MiaKoring/BasedChat/issues/6
            .alert(LocalizedStringKey(commandError?.localizedDescription ?? ""), isPresented: $commandErrorShown){
                
            }
            .onChange(of: sendSticker) {
                DispatchQueue.global().async {
                    var message: Message? = nil
                    if replyTo.isNil {
                        message = Message(time: Date().intTimeIntervalSince1970, sender: 1, type: .sticker, text: "", messageID: chat.currentMessageID + 1, isRead: false, formattedChars: [], stickerPath: stickerPath)
                    }
                    else {
                        message = Message(time: Date().intTimeIntervalSince1970, sender: 1, type: .stickerReply, reply: replyTo, text: "", messageID: chat.currentMessageID + 1, isRead: false, formattedChars: [], stickerPath: stickerPath)
                    }
                    DispatchQueue.main.async {
                        sendMessage(message!)
                        chat.currentMessageID += 1
                    }
                }
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
    @State var showStickerDetail = false
    @State var bottomCardReaction: Reaction? = nil
    @State private var keyboardShown: Bool = false
    @State var replyTo: Reply? = nil
    @State var newMessageSent = false
    @State var messageToDelete: Message? = nil
    @State var relevantCommands: [any Command] = []
    @State var messageInput: String = ""
    @State var collection: CommandCollection = CommandCollection(commands: [])
    @State var currentCommand: (any Command)? = nil
    @State var sender: Int = 0 //TODO: Only Test
    @State var messageSent = false
    @State var commandErrorShown = false
    @State var commandError: CommandError? = nil
    @State var sendSticker = false
    @State var stickerPath = ""
    
    //MARK: -
}

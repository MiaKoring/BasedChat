import SwiftUI
import RealmSwift
import SlashCommands
import SwiftChameleon

struct ChatView: View {
    //MARK: - Body
    
    var body: some View {
        VStack {
            MessageScrollView(chat: chat, showStickerDetail: $showStickerDetail, bottomCardReaction: $bottomCardReaction, replyTo: $replyTo, newMessageSent: $newMessageSent, messageToDelete: $messageToDelete, appendMessage: $appendMessage, keyboardShown: $keyboardShown)
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
            ChatInputView(replyTo: $replyTo, messageInput: $messageInput, chat: chat, messageSent: $messageSent, sender: $sender, sendSticker: $sendSticker)
        }
            .padding(.horizontal, 10)
            .onTapGesture {
                hideKeyboard()
            }
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
                .presentationDragIndicator(.visible)
            }
        #if canImport(UIKit)
            .ignoresSafeAreaWith(condition: UIDevice.isIPhone, regions: .container, edges: .top)
        #else
            .ignoresSafeArea(.container, edges: .top)
        #endif
            .navigationBarBackButtonHidden()
            .overlay {
                ChatTopBar(showNavigation: $showNavigation, chat: chat) //TODO: add adaptive functionality
            }
            .onChange(of: messageSent) {
                handleMessageSend()
            }
            .onAppear() {
                collection = CommandCollection(commands: [
                    Bababa(completion: sendBababa),
                    Tableflip(completion: sendTableflip),
                    Unflip(completion: sendUnflip)
                ])
            }
            .onChange(of: bottomCardReaction) {} //somehow seems to fix https://github.com/MiaKoring/BasedChat/issues/6
            .alert(LocalizedStringKey(commandError?.localizedDescription ?? ""), isPresented: $commandErrorShown){
                
            }
            .onChange(of: sendSticker) {
                sendStickerChanged()
            }
    }
    
    //MARK: - Parameters
    
    @ObservedRealmObject var chat: Chat
    #if canImport(UIKit)
    @Environment(\.safeAreaInsets) var safeAreaInsets
    #endif
    @State var scrollTo: UUID? = UUID()
    @State var triggerScroll = false
    @State var showLoading: Bool = false
    @State var showStickerDetail = false
    @State var bottomCardReaction: BuiltReactions? = nil
    @State private var keyboardShown: Bool = false
    @State var replyTo: Message? = nil
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
    @State var sendSticker: SendableSticker = SendableSticker(name: "", hash: "", type: "")
    @Binding var showNavigation: NavigationSplitViewVisibility
    @State var appendMessage: Message? = nil
    
    //MARK: -
}

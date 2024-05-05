import Foundation
import SwiftUI
import SlashCommands

struct ChatInputView: View {
    //MARK: - Bodyub
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .contextMenu(ContextMenu(menuItems: {
                    Button {
                        createMessage(2)
                    } label: {
                        Text("regular")
                    }
                    Button {
                        sender = 1
                        stickerPath = "integratedTalkingCat"
                        sendSticker.toggle()
                    } label: {
                        Text("Babbelgadse")
                    }
                }))
            TextField("", text: $messageInput, axis: .vertical)
                .messageInputStyle()
            Button {
                createMessage()
            } label: {
                Image(systemName: "paperplane")
            }
            .alert(LocalizedStringKey("EmptyMessageAlert"), isPresented: $showMessageEmptyAlert) {
                Button("OK", role: .cancel){}
            }
        }
    }
    
    //MARK: - Parameters
    
    @Binding var replyTo: Reply?
    @Binding var messageInput: String
    @State var showMessageEmptyAlert = false
    @Binding var chat: Chat
    @Binding var messageSent: Bool
    @Binding var sender: Int //TODO: Only Test
    @Binding var sendSticker: Bool
    @Binding var stickerPath: String
    
    //MARK: -
}

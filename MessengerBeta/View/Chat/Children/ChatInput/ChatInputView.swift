import Foundation
import SwiftUI
import SlashCommands

struct ChatInputView: View {
    //MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                createMessage(2)
            } label: {
                Image(systemName: "plus")
            }
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
    
    //MARK: -
}

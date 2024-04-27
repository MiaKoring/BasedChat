import Foundation
import SwiftUI

struct ChatInputView: View {
    //MARK: - Body
    
    var body: some View {
        HStack{
            Button{
                createMessage(2)
                print("should be stored")
            }label: {
                Image(systemName: "plus")
            }
            TextField("", text: $messageInput, axis: .vertical)
                .messageInputStyle()
            Button{
                createMessage()
            } label: {
                Image(systemName: "paperplane")
            }
            .alert(LocalizedStringKey("EmptyMessageAlert"), isPresented: $showMessageEmptyAlert){
                Button("OK", role: .cancel){}
            }
        }
    }
    
    //MARK: - Parameters
    @Binding var replyTo: Reply?
    @Binding var newMessage: Message?
    @State var messageInput: String = ""
    @State var showMessageEmptyAlert = false
    @Binding var chat: Chat
}

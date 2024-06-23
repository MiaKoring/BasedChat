import Foundation
import SwiftUI
import SlashCommands

struct ChatInputView: View {
    //MARK: - Bodyub
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 18))
                    .contextMenu(ContextMenu(menuItems: {
                        Button {
                            createMessage(2)
                        } label: {
                            Text("regular")
                        }
                        Button {
                            sender = 2
                            stickerPath = "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b"
                            sendSticker.toggle()
                        } label: {
                            Text("Babbelgadse")
                        }
                    }))
                HStack{
                    TextField("", text: $messageInput, axis: .vertical)
                        .lineLimit(3)
                        .focused($textFieldFocused)
                    Image("sticker.bold")
                        .font(.system(size: 18))
                        .onTapGesture {
                            showStickerSheet.toggle()
                        }
                }
                .messageInputStyle()
                Button {
                    createMessage()
                } label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: 18))
                }
                .alert(LocalizedStringKey("EmptyMessageAlert"), isPresented: $showMessageEmptyAlert) {
                    Button("OK", role: .cancel){}
                }
            }
            .sheet(isPresented: $showStickerSheet) {
                TopTabView(stickerPath: $stickerPath, sendSticker: $sendSticker)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThickMaterial)
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
    @FocusState var textFieldFocused: Bool
    @State var showStickerSheet: Bool = false
    @State var sysCommandInput: String = ""
    
    //MARK: -
}

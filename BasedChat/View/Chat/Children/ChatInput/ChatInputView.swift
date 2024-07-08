import Foundation
import SwiftUI
import SlashCommands
import RealmSwift

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
                    }))
                HStack{
                    TextField("", text: $messageInput, axis: .vertical)
                        .lineLimit(3)
                        .focused($textFieldFocused)
                    Image("sticker.bold")
                        .font(.system(size: 18))
                        .background {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.ultraThinMaterial)
                        }
                        .onTapGesture {
                            showStickerSheet.toggle()
                        }
                }
                .messageInputStyle(textFieldFocused: $textFieldFocused)
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
                TopTabView(sendSticker: $sendSticker)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(.ultraThickMaterial)
            }
        }
    }
    
    //MARK: - Parameters
    
    @Binding var replyTo: Message?
    @Binding var messageInput: String
    @State var showMessageEmptyAlert = false
    @ObservedRealmObject var chat: Chat
    @Binding var messageSent: Bool
    @Binding var sender: Int //TODO: Only Test
    @Binding var sendSticker: SendableSticker
    @FocusState var textFieldFocused: Bool
    @State var showStickerSheet: Bool = false
    @State var sysCommandInput: String = ""
    
    //MARK: -
}

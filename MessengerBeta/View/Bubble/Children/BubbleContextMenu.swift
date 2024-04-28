import Foundation
import SwiftUI

struct BubbleContextMenu: View {
    //MARK: - Body
    
    var body: some View {
        Text(DateHandler.formatBoth(message.time, lang: "de_DE"))
        
        Button {
            replyTo = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                replyTo = Reply(originID: message.id, text: message.text, sender: message.sender)
            }
        } label: {
            Label(LocalizedStringKey("Reply"), systemImage: "arrowshape.turn.up.left")
        }
        
        Button(role: .destructive) {
            deleteAlertPresented = true
        } label: {
            Label(LocalizedStringKey("Delete"), systemImage: "trash")
        }
    }
    //MARK: - Parameters
    
    let message: Message
    @Environment(\.modelContext) var context
    @Binding var replyTo: Reply?
    @Binding var deleteAlertPresented: Bool
    
    //MARK: -
}

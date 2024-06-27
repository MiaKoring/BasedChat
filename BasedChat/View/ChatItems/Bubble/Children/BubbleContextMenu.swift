import Foundation
import SwiftUI
import RealmSwift

struct BubbleContextMenu: View {
    //MARK: - Body
    
    var body: some View {
        Text(DateHandler.formatBoth(message.time, lang: "de_DE"))
        
        Button {
            replyTo = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                replyTo = message
            }
        } label: {
            Label(LocalizedStringKey("Reply"), systemImage: "arrowshape.turn.up.left")
        }
        
        Button {
            try? realm.write {
                let message = message.thaw()
                let contacts = realm.objects(Contact.self)
                let arr = contacts.where {
                    $0.userID == BasedChatApp.currentUserID
                }
                let sender = arr.first!
                message?.reactions.append(Reaction(reaction: "❤️", sender: sender))
            }
        } label: {
            Label("Like", systemImage: "star")
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
    @Binding var replyTo: Message?
    @Binding var deleteAlertPresented: Bool
    
    //MARK: -
}

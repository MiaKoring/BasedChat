import Foundation
import SwiftUI
import RealmSwift

public struct AnswerDisplayView: View {
    //MARK: - Body
    
    public var body: some View {
        if let reply = message.reply {
            VStack(alignment: .leading, spacing: 5) {
                Text(senderName)
                    .bold()
                    .font(.system(size: 14))
                Text(reply.text.count > 150 ? "\(reply.text.prefix(150).prefix(upTo: reply.text.prefix(150).lastIndex(of: " ") ?? reply.text.prefix(150).endIndex))..." : reply.text)
                    .font(.system(size: 12))
            }
            .padding(3)
            .onAppear() {
                let contacts = realm.objects(Contact.self)
                let arr = contacts.where {
                    $0.userID == reply.sender
                }
                guard let sender = arr.first else {
                    senderName = "notFound"
                    return
                }
                senderName = sender.savedAs.isNotEmpty ? sender.savedAs : sender.username
            }
        }
    }
    
    //MARK: - Parameters
    @ObservedRealmObject var message: Message
    @State var senderName = "Loading..."
}

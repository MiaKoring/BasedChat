import SwiftUI
import RealmSwift

struct ReplyToDisplayView: View {
    //MARK: - Body
    
    var body: some View {
        if let origin = replyTo {
            VStack(alignment: .leading, spacing: 5) {
                Text(originSenderName)
                    .bold()
                    .font(.system(size: 14))
                Text(origin.text)
                    .font(.system(size: 12))
            }
            .padding(3)
            .onAppear() {
                originMessage = getText()
                guard let sender = replyTo?.sender.first else {
                    originSenderName = "Sender not found"
                    return
                }
                originSenderName = sender.savedAs.isNotEmpty ? sender.savedAs : sender.username
            }
        }
    }
    
    //MARK: - Parameters
    @Binding var replyTo: Message?
    @State var originSenderName: String = ""
    @State var originMessage: String = ""
}

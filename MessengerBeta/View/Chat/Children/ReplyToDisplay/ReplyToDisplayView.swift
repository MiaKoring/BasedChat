import SwiftUI
import SwiftData

struct ReplyToDisplayView: View {
    //MARK: - Body
    
    var body: some View {
        if replyTo != nil {
            VStack(alignment: .leading, spacing: 5) {
                Text(originSenderName)
                    .bold()
                    .font(.system(size: 14))
                Text(originMessage)
                    .font(.system(size: 12))
            }
            .padding(3)
            .onAppear() {
                originSenderName = (contacts.first?.savedAs ?? contacts.first?.username) ?? "unknown"
                originMessage = getText()
            }
        }
    }
    
    //MARK: - Parameters
    
    @Binding var replyTo : Reply?
    @State var originSenderName: String
    @State var originMessage : String
    @Query var contacts: [Contact]
    
    //MARK: - Initializer
    
    init(replyTo: Binding<Reply?>, originSenderName: String = "", originMessage: String = "") {
        self._replyTo = replyTo
        self.originSenderName = originSenderName
        self.originMessage = originMessage
        let sender = self.replyTo!.sender
        self._contacts = Query(filter: #Predicate<Contact>{
            $0.userID == sender
        })
    }
    
    //MARK: -
}

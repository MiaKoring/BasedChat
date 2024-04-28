import Foundation
import SwiftUI
import SwiftData

public struct AnswerDisplayView: View {
    //MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(senderName)
                .bold()
                .font(.system(size: 14))
            Text(text.count > 150 ? "\(text.prefix(150).prefix(upTo: text.prefix(150).lastIndex(of: " ") ?? text.prefix(150).endIndex))..." : text)
                .font(.system(size: 12))
        }
        .padding(3)
        .onAppear() {
            senderName = (contacts.first?.savedAs ?? contacts.first?.username) ?? "unknown"
        }
    }
    
    //MARK: - Parameters
    
    @State var text: String
    @State var sender: Int
    @State var senderName: String
    @State var originMessageID: UUID
    @Query var contacts: [Contact]
    
    //MARK: - Initializer
    
    init(text: String, sender: Int, senderName: String = "", originMessageID: UUID) {
        self.text = text
        self.sender = sender
        self.senderName = senderName
        self.originMessageID = originMessageID
        self._contacts = Query(filter: #Predicate<Contact>{
            $0.userID == sender
        })
    }
    
    //MARK: -
}

import SwiftUI
import SwiftData

extension Dictionary where Value: Equatable{
    func keys(forValue value: Value)-> [Key]{
        return compactMap{ (key, element) in
            return element == value ? key : nil
            
        }
    }
}

let testMessageUUID: UUID = UUID()

let testChatUUID: UUID = UUID()

let testMessagesUUID: UUID = UUID()

struct ContentView: View{
    @Query var chats: [Chat]
    @Query var msgs: [Message]
    @Environment(\.modelContext) var context
    
    var body: some View {
        if !chats.isEmpty{
            ChatView(messagesID: chats.first!.messagesID)
        }
        else{
            Text("renderfehler")
                .onAppear(){
                    if chats.isEmpty || msgs.isEmpty{
                        for chat in chats {
                            context.delete(chat)
                        }
                        for msg in msgs {
                            context.delete(msg)
                        }
                        for defaultMessage in defaultMessages {
                            context.insert(defaultMessage)
                        }
                        context.insert(defaultChat)
                    }
                }
        }
    }
}


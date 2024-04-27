import Foundation
extension ChatView{
    func deleteMessage(){
        if messageToDelete == nil { return }
        chat.messages.removeAll(where: {$0.id == messageToDelete!.id})
    }
    
    func sendMessage(_ newMessage: Message?){
        if newMessage != nil{
            chat.messages.append(newMessage!)
            chat.currentMessageID += 1
            newMessageSent.toggle()
            #if canImport(UIKit)
                hideKeyboard()
            #endif
        }
    }
}

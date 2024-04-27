import Foundation

extension ChatInputView{
    func createMessage(_ sender: Int = BasedChatApp.currentUserID ?? 0){
        if messageInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            showMessageEmptyAlert = true
            return
        }
        if replyTo == nil{
            newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: messageInput, messageID: chat.currentMessageID + 1, isRead: false)
            messageInput = ""
            return
        }
        newMessage = Message(time: Int(Date().intTimeIntervalSince1970), sender: sender, type: "reply", reply: replyTo!, text: messageInput, messageID: chat.currentMessageID + 1, isRead: false)
        replyTo = nil
        messageInput = ""
    }
}

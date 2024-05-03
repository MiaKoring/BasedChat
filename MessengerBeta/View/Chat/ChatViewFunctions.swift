import Foundation
import SlashCommands

extension ChatView {
    func commandListHeight()-> Double {
        if relevantCommands.count == 1 { return 60.0 }
        if relevantCommands.count == 2 { return 100.0 }
        if relevantCommands.count > 2 { return 125.0 }
        return 0.0
    }
    
    func deleteMessage() {
        if messageToDelete == nil { return }
        chat.messages.removeAll(where: {$0.id == messageToDelete!.id})
    }
    
    func handleMessageSend() {
        if handleCommand() {
            currentCommand = nil
            replyTo = nil
            messageInput = ""
            return
        }
        
        let newMessage = generateMessage()
        sendMessage(newMessage)
    }
    
    fileprivate func generateMessage()-> Message {
        var newMessage: Message? = nil
        if replyTo == nil {
            newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: messageInput, messageID: chat.currentMessageID + 1, isRead: false)
        }
        else {
            newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: "reply", reply: replyTo!, text: messageInput, messageID: chat.currentMessageID + 1, isRead: false)
        }
        replyTo = nil
        messageInput = ""
        return newMessage!
    }
    
    fileprivate func sendMessage(_ newMessage: Message) {
        chat.messages.append(newMessage)
        chat.currentMessageID += 1
        newMessageSent.toggle()
        #if canImport(UIKit)
            hideKeyboard()
        #endif
    }
    
    fileprivate func handleCommand()-> Bool {
        if currentCommand != nil {
            do {
                try collection.execute(currentCommand!, with: messageInput, highestPermission: .none) //TODO: add permissions to user
                return true
            }
            catch let error{
                print(error.localizedDescription)
            }
        }
        return false
    }
    
    func comp(_ params: [String: Any])-> Void {
        var msgStr = ""
        if params.isEmpty {
            msgStr = "(╯°□°)╯︵ ┻━┻"
        }
        else {
            msgStr = "\(params["message"] as! String) (╯°□°)╯︵ ┻━┻"
        }
        if replyTo == nil {
            let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true)
            sendMessage(newMessage)
            return
        }
        let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: "reply", reply: replyTo!, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true)
        sendMessage(newMessage)
        return
    }
    
    func complete(_ params: [String: Any])-> Void {
        var msgStr = ""
        if params.isEmpty {
            msgStr = "bababa"
        }
        else {
            msgStr = "\(params["message"] as! String) bababa"
        }
        if replyTo == nil {
            let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true)
            sendMessage(newMessage)
            return
        }
        let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: "reply", reply: replyTo!, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true)
        sendMessage(newMessage)
        return
    }
    
    func unflipComplete(_ params: [String: Any])-> Void {
        var msgStr = ""
        if params.isEmpty {
            msgStr = "┬─┬ノ( º _ ºノ)"
        }
        else {
            msgStr = "\(params["message"] as! String) ┬─┬ノ( º _ ºノ)"
        }
        if replyTo == nil {
            let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true)
            sendMessage(newMessage)
            return
        }
        let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: "reply", reply: replyTo!, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true)
        sendMessage(newMessage)
        return
    }
}

import Foundation
import SlashCommands
import SwiftChameleon

extension ChatView {
    func commandListHeight()-> Double {
        if relevantCommands.count == 1 { return 60.0 }
        if relevantCommands.count == 2 { return 100.0 }
        if relevantCommands.count > 2 { return 125.0 }
        return 0.0
    }
    
    func deleteMessage() {
        DispatchQueue.main.async {
            if messageToDelete.isNil { return }
            chat.messages.removeAll(where: {$0.id == messageToDelete!.id})
        }
    }
    
    func handleMessageSend() {
        DispatchQueue.global(qos: .background).async {
            if handleCommand() {
                DispatchQueue.main.async {
                    currentCommand = nil
                    replyTo = nil
                    messageInput = ""
                }
                return
            }
            
            let newMessage = generateMessage()
            DispatchQueue.main.async {
                replyTo = nil
                messageInput = ""
                sendMessage(newMessage)
            }
        }
    }
    
    fileprivate func generateMessage()-> Message {
        var newMessage: Message? = nil
        let formattedChars = StringFormatterCollection.formatChars(messageInput)
        
        if replyTo.isNil {
            newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: messageInput, messageID: chat.currentMessageID + 1, isRead: false, formattedChars: formattedChars)
        }
        else {
            newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .reply, reply: replyTo!, text: messageInput, messageID: chat.currentMessageID + 1, isRead: false, formattedChars: formattedChars)
        }
        return newMessage!
    }
    
    func sendMessage(_ newMessage: Message) {
        chat.messages.append(newMessage)
        chat.currentMessageID += 1
        newMessageSent.toggle()
        
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
        let formattedChars = StringFormatterCollection.formatChars(msgStr)
        if replyTo.isNil {
            let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true, formattedChars: formattedChars)
            DispatchQueue.main.async {
                sendMessage(newMessage)
            }
            return
        }
        let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .reply, reply: replyTo!, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true, formattedChars: formattedChars)
        DispatchQueue.main.async {
            sendMessage(newMessage)
        }
        return
    }
    
    func complete(_ params: [String: Any])-> Void {
        var msg: Message? = nil
        if params.isEmpty {
            if replyTo.isNil {
                msg = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .sticker, text: "", messageID: chat.currentMessageID + 1, isRead: true, formattedChars: [], stickerHash: "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b")
            }
            else {
                msg = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .stickerReply, reply: replyTo!, text: "", messageID: chat.currentMessageID + 1, isRead: true, formattedChars: [], stickerHash: "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b")
            }
        }
        else {
            if replyTo.isNil {
                var messageInputString = params["message"]! as! String
                messageInputString = messageInputString.trimmingCharacters(in: .whitespacesAndNewlines)
                let formattedChars = StringFormatterCollection.formatChars(messageInputString)
                
                let firstMSG = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: messageInputString, messageID: chat.currentMessageID + 1, isRead: true, formattedChars: formattedChars)
                
                DispatchQueue.main.async {
                    sendMessage(firstMSG)
                }
                
                msg = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .stickerReply, reply: Reply(originID: firstMSG.id, text: firstMSG.text, sender: firstMSG.sender), text: "", messageID: chat.currentMessageID + 1, isRead: true, formattedChars: [], stickerHash: "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b")
            }
            else {
                var messageInputString = params["message"]! as! String
                messageInputString = messageInputString.trimmingCharacters(in: .whitespacesAndNewlines)
                let formattedChars = StringFormatterCollection.formatChars(messageInputString)
                
                let firstMSG = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .reply, reply: replyTo, text: messageInputString, messageID: chat.currentMessageID + 1, isRead: true, formattedChars: formattedChars)
                
                
                DispatchQueue.main.async {
                    sendMessage(firstMSG)
                }
                
                msg = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .stickerReply, reply: Reply(originID: firstMSG.id, text: firstMSG.text, sender: firstMSG.sender), text: "", messageID: chat.currentMessageID + 1, isRead: true, formattedChars: [], stickerHash: "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b")
            }
        }
        DispatchQueue.main.async {
            sendMessage(msg!)
            print(msg!)
        }
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
        let formattedChars = StringFormatterCollection.formatChars(msgStr)
        if replyTo.isNil {
            let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true, formattedChars: formattedChars)
            sendMessage(newMessage)
            return
        }
        let newMessage = Message(time: Date().intTimeIntervalSince1970, sender: sender, type: .reply, reply: replyTo!, text: msgStr, messageID: chat.currentMessageID + 1, isRead: true, formattedChars: formattedChars)
        DispatchQueue.main.async {
            sendMessage(newMessage)
        }
        return
    }
    
    func sendStickerChanged(){
        DispatchQueue.global().async {
            var message: Message? = nil
            if replyTo.isNil {
                message = Message(time: Date().intTimeIntervalSince1970, sender: 1, type: .sticker, text: "", messageID: chat.currentMessageID + 1, isRead: false, formattedChars: [], stickerHash: stickerPath)
            }
            else {
                message = Message(time: Date().intTimeIntervalSince1970, sender: 1, type: .stickerReply, reply: replyTo, text: "", messageID: chat.currentMessageID + 1, isRead: false, formattedChars: [], stickerHash: stickerPath)
            }
            DispatchQueue.main.async {
                sendMessage(message!)
                chat.currentMessageID += 1
            }
        }
    }
}

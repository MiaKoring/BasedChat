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
            deleteMessageFromChat()
            deleteMessageFromContact()
        }
    }
    
    fileprivate func deleteMessageFromChat() {
        guard let index = chat.messages.firstIndex(where: {
            $0.messageUUID == messageToDelete?.messageUUID
        }) else {
            return
        }
        try? realm.write {
            let new = chat.thaw()!
            new.messages.remove(at: index)
        }
    }
    
    fileprivate func deleteMessageFromContact() {
        guard var contact = chat.participants.first(where: {
            $0.userID == messageToDelete?.sender.first?.userID
        }) else {
            return
        }
        guard let index = contact.messages.firstIndex(where: {
            $0.messageUUID == messageToDelete?.messageUUID
        }) else {
            return
        }
        try? realm.write {
            let new = contact.thaw()!
            new.messages.remove(at: index)
        }
    }
    
    func handleMessageSend() {
        DispatchQueue.global(qos: .background).async {
            if handleCommand() {
                return
            }
            
            DispatchQueue.main.async {
                let newMessage = generateMessage()
                messageInput = ""
                sendMessage(newMessage)
            }
        }
    }
    
    fileprivate func generateMessage()-> Message {
        let formattedSubstrs = StringFormatterCollection.formatSubstrs(messageInput)
        
        guard let reply = replyTo else {
            let newMessage = Message(time: Date().intTimeIntervalSince1970, type: .standalone, text: messageInput, messageID: chat.currentMessageID + 1)
            
            for substr in formattedSubstrs {
                try? realm.write {
                    newMessage.formattedSubstrings.append(substr)
                }
            }
            return newMessage
        }
        let newMessage = Message(time: Date().intTimeIntervalSince1970, type: .reply, reply: Reply(originID: reply.messageUUID, text: reply.text, sender: reply.sender.first?.userID ?? 0), text: messageInput, messageID: chat.currentMessageID + 1)
        
        for substr in formattedSubstrs {
            try? realm.write {
                newMessage.formattedSubstrings.append(substr)
            }
        }
        return newMessage
    }
    
    func sendMessage(_ newMessage: Message) {
        //TODO: Add error handling
        replyTo = nil
        try? realm.write {
            let chat = chat.thaw()!
            chat.messages.append(newMessage)
            chat.currentMessageID += 1
            guard let participant = chat.participants.first(where: {
                $0.userID == BasedChatApp.currentUserID
            }) else {
                newMessageSent.toggle()
                return
            }
            participant.thaw()!.messages.append(newMessage)
        }
        newMessageSent.toggle()
    }
    
    fileprivate func handleCommand()-> Bool {
        guard let command = currentCommand else { return false }
        do {
            try collection.execute(command, with: messageInput, highestPermission: .none)
            DispatchQueue.main.async {
                currentCommand = nil
                replyTo = nil
                messageInput = ""
            }
            return true
        }
        catch let error{
            print(error.localizedDescription)
            return false
        }
            
    }
    
    func sendAppendedMessage(_ message: String, append: String){
        var msgStr = ""
        if message.isEmpty {
            msgStr = append
        }
        else {
            msgStr = "\(message) \(append)"
        }
        let formattedSubstr = StringFormatterCollection.formatSubstrs(msgStr)
        guard let reply = replyTo else {
            let newMessage = Message(time: Date().intTimeIntervalSince1970, type: .standalone, text: msgStr, messageID: chat.currentMessageID + 1)
            for substring in formattedSubstr {
                newMessage.formattedSubstrings.append(substring)
            }
            DispatchQueue.main.async {
                sendMessage(newMessage)
            }
            return
        }
        DispatchQueue.main.async {
            try? realm.write {
                let repl = Reply(originID: reply.messageUUID, text: reply.text, sender: reply.sender.first?.userID ?? 0)
                
                let newMessage = Message(time: Date().intTimeIntervalSince1970, type: .reply, reply: repl, text: msgStr, messageID: chat.currentMessageID + 1)
                for substring in formattedSubstr {
                    newMessage.formattedSubstrings.append(substring)
                }
                sendMessage(newMessage)
            }
        }
    }
    
    func sendTableflip(_ params: [String: Any])-> Void {
        sendAppendedMessage(params["message"] as? String ?? "", append: "(╯°□°)╯︵ ┻━┻")
        return
    }
    
    func sendUnflip(_ params: [String: Any])-> Void {
        sendAppendedMessage(params["message"] as? String ?? "", append: "┬─┬ノ( º _ ºノ)")
        return
    }
    
    func sendBababa(_ params: [String: Any])-> Void {
        let stickerHash = "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b"
        if params.isEmpty {
            guard let reply = replyTo else {
                let msg = Message(time: Date().intTimeIntervalSince1970, type: .sticker, text: "", messageID: chat.currentMessageID + 1, stickerHash: stickerHash, stickerName: "Bababa", stickerType: "gif")
                DispatchQueue.main.async {
                    sendMessage(msg)
                }
                return
            }
            let msg = Message(time: Date().intTimeIntervalSince1970, type: .stickerReply, reply: Reply(originID: reply.messageUUID, text: reply.text, sender: reply.sender.first?.userID ?? 0), text: "", messageID: chat.currentMessageID + 1, stickerHash: stickerHash, stickerName: "Bababa", stickerType: "gif")
            DispatchQueue.main.async {
                sendMessage(msg)
            }
            return
        }
        else {
            var messageInputString = params["message"]! as! String
            messageInputString = messageInputString.trimmingCharacters(in: .whitespacesAndNewlines)
            let formattedSubstrs = StringFormatterCollection.formatSubstrs(messageInputString)
            guard let reply = replyTo else {
                let firstMSG = Message(time: Date().intTimeIntervalSince1970, type: .standalone, text: messageInputString, messageID: chat.currentMessageID + 1)
                
                for substr in formattedSubstrs {
                    try? realm.write {
                        firstMSG.formattedSubstrings.append(substr)
                    }
                }
                
                DispatchQueue.main.async {
                    sendMessage(firstMSG)
                }
                
                let msg = Message(time: Date().intTimeIntervalSince1970, type: .stickerReply, reply: Reply(originID: firstMSG.messageUUID, text: firstMSG.text, sender: firstMSG.sender.first?.userID ?? 0), text: "", messageID: chat.currentMessageID + 1, stickerHash: stickerHash, stickerName: "Bababa", stickerType: "gif")
                DispatchQueue.main.async {
                    sendMessage(msg)
                }
                return
            }
            
            let firstMSG = Message(time: Date().intTimeIntervalSince1970, type: .reply, reply: Reply(originID: reply.messageUUID, text: reply.text, sender: reply.sender.first?.userID ?? 0), text: messageInputString, messageID: chat.currentMessageID + 1)
            
            for substr in formattedSubstrs {
                try? realm.write {
                    firstMSG.formattedSubstrings.append(substr)
                }
            }
            
            DispatchQueue.main.async {
                sendMessage(firstMSG)
            }
            
            let msg = Message(time: Date().intTimeIntervalSince1970, type: .stickerReply, reply: Reply(originID: firstMSG.messageUUID, text: firstMSG.text, sender: firstMSG.sender.first?.userID ?? 0), text: "", messageID: chat.currentMessageID + 1, stickerHash: stickerHash, stickerName: "Bababa", stickerType: "gif")
            
            DispatchQueue.main.async {
                sendMessage(msg)
            }
            return
        }
    }
    
    func sendStickerChanged(){
        DispatchQueue.main.async {
            guard let reply = replyTo else {
                let message = Message(time: Date().intTimeIntervalSince1970, type: .sticker, text: "", messageID: chat.currentMessageID + 1, stickerHash: sendSticker.hash, stickerName: sendSticker.name, stickerType: sendSticker.type)
                sendMessage(message)
                return
            }
            let repl = Reply(originID: reply.messageUUID, text: reply.text, sender: reply.sender.first?.userID ?? 0)
            
            sendMessage(
                Message(time: Date().intTimeIntervalSince1970, type: .stickerReply, reply: repl, text: "", messageID: chat.currentMessageID + 1, stickerHash: sendSticker.hash, stickerName: sendSticker.name, stickerType: sendSticker.type)
            )
        }
    }
}

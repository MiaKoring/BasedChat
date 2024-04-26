extension ChatView{
    func deleteMessage(){
        if messageToDelete == nil { return }
        chat.messages.removeAll(where: {$0.id == messageToDelete!.id})
    }
}

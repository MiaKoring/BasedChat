extension Message {
    var senderIsCurrentUser: Bool {
        guard let sender = self.sender.first else { return false }
        return sender.userID.isCurrentUser
    }
}

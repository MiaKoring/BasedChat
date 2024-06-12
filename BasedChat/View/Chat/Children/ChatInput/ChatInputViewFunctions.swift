import Foundation

extension ChatInputView {
    func createMessage(_ msgSender: Int = BasedChatApp.currentUserID ?? 0) {
        if messageInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showMessageEmptyAlert = true
            return
        }
        sender = msgSender
        messageSent.toggle()
    }
}

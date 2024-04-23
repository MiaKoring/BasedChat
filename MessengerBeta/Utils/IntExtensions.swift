import Foundation
import Security

extension Int {
    var isCurrentUser: Bool {
        self == BasedChatApp.currentUserID
    }
}

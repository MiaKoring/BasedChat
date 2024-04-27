import SwiftData
import Foundation

@Model
final class Contact: Identifiable{
    var userID: Int
    var username: String
    var publicKey: String
    var savedAs: String?
    var isLocalUser: Bool
    var chats: [UUID]
    
    init(userID: Int, username: String, publicKey: String, savedAs: String? = nil, isLocalUser: Bool = false, chats: [UUID] = []) {
        self.userID = userID
        self.username = username
        self.publicKey = publicKey
        self.savedAs = savedAs
        self.isLocalUser = isLocalUser
        self.chats = chats
    }
}

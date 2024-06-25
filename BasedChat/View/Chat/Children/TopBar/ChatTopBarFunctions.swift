import Foundation
import SwiftData
import MediaPlayer
import Combine

extension ChatTopBar {
    func appeared() {
        if ChatType(rawValue: chat.type) == .direct {
            guard
                let reciepient = chat.participants.first(where: {!$0.isCurrentUser}),
                let reciepientContact = try? context.fetch(FetchDescriptor(predicate: #Predicate<Contact>{
                    $0.userID == reciepient
                })).first else {
                print("Contact not found")
                return
            }
            contact = reciepientContact
            title = contact?.savedAs ?? contact?.username ?? "Not Found"
            
        }
        //TODO: add Group
        loadImage()
    }
    
    func disappeared() {
        NotificationCenter.default.removeObserver(self)
        #if os(iOS)
        MPMusicPlayerController.systemMusicPlayer.endGeneratingPlaybackNotifications()
        #endif
    }
    
    func loadImage() {
        DispatchQueue.global().async {
            if let res = FileHandler.loadFileIntern(fileName: "\(contact?.imagehash ?? "").jpg") {
                DispatchQueue.main.async {
                    data = res
                }
            }
            else {
                print("failed to load image")
            }
        }
    }
    
    func eventIsActive()-> Bool {
        true
    }
}

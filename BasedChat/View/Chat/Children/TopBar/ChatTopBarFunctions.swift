import Foundation
import MediaPlayer
import Combine

extension ChatTopBar {
    func appeared() {
        if ChatType(rawValue: chat.type) == .direct {
            let reciepient = chat.participants.first(where: {!$0.userID.isCurrentUser})
            contact = reciepient
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
            if let res = FileHandler.loadFileIntern(fileName: "\(contact?.pfpHash ?? "").jpg") {
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

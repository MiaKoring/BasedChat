import Foundation

extension Message {
    var isSticker: Bool {
        self.type == MessageType.sticker.rawValue || self.type == MessageType.stickerReply.rawValue
    }
}

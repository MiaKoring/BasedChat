import Foundation
import SwiftUI

struct ReactionDisplayView: View {
    //MARK: - Body
    
    var body: some View {
        if reactionData != nil {
            if !reactionContainer.isEmpty && Double(reactionContainer.count) * 1.2 <= Double(textCount) {
                if !opaque {
                    Text(reactionContainer)
                        .reactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: reactionData!, showStickerDetail: $showStickerDetail, senderIsCurrent: sender.isCurrentUser)
                }
                else {
                    Text(reactionContainer)
                        .stickerReactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: reactionData!, showStickerDetail: $showStickerDetail, senderIsCurrent: sender.isCurrentUser)
                }
            }
            else if !reactionContainer.isEmpty {
                if !opaque {
                    Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                        .reactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: reactionData!, showStickerDetail: $showStickerDetail, senderIsCurrent: sender.isCurrentUser)
                }
                else {
                    Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                        .stickerReactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: reactionData!, showStickerDetail: $showStickerDetail, senderIsCurrent: sender.isCurrentUser)
                }
            }
        }
    }
    
    //MARK: - Parameters
    
    let reactionContainer: String
    let textCount: Int
    let reactionData: Reaction?
    let sender: Int
    let opaque: Bool
    @Binding var bottomCardReaction: Reaction?
    @Binding var showStickerDetail: Bool
    
    //MARK: - Initializer
    
    //MARK: -
}

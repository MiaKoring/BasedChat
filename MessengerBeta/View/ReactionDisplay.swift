import Foundation
import SwiftUI

struct ReactionDisplay: View {
    let reactionContainer: String
    let textCount: Int
    let reactionData: Reaction?
    let sender: Int
    @Binding var bottomCardReaction: Reaction?
    @Binding var bottomCardOpen: Bool
    var body: some View {
        if reactionData != nil{
            if !reactionContainer.isEmpty && Double(reactionContainer.count) * 1.2 <= Double(textCount){
                Text(reactionContainer)
                    .reactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: reactionData!, bottomCardOpen: $bottomCardOpen, senderIsCurrent: sender.isCurrentUser)
            }
            else if !reactionContainer.isEmpty{
                Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                    .reactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: reactionData!, bottomCardOpen: $bottomCardOpen, senderIsCurrent: sender.isCurrentUser)
            }
        }
    }
}

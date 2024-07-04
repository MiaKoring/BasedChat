import Foundation
import SwiftUI
import RealmSwift

struct ReactionDisplayView: View, ReactionInfluenced {
    //MARK: - Body
    
    var body: some View {
        VStack {
            if !message.reactions.isEmpty {
                if !reactionContainer.isEmpty && Double(reactionContainer.count) * 1.2 <= Double(message.text.count) {
                    if let data = reactionData, !opaque {
                        Text(reactionContainer)
                            .reactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: data, showStickerDetail: $showStickerDetail, senderIsCurrent: message.senderIsCurrentUser)
                    }
                    else if let data = reactionData {
                        Text(reactionContainer)
                            .stickerReactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: data, showStickerDetail: $showStickerDetail, senderIsCurrent: message.senderIsCurrentUser)
                    }
                }
                else if !reactionContainer.isEmpty {
                    if let data = reactionData, !opaque {
                        Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                            .reactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: data, showStickerDetail: $showStickerDetail, senderIsCurrent: message.senderIsCurrentUser)
                    }
                    else if let data = reactionData {
                        Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                            .stickerReactionDisplayStyle(bottomCardReaction: $bottomCardReaction, reactionData: data, showStickerDetail: $showStickerDetail, senderIsCurrent: message.senderIsCurrentUser)
                    }
                }
            }
        }
        .onAppear() {
            if !message.reactions.isEmpty {
                reactionData = genReactions()
                guard let data = reactionData else { return }
                reactionContainer = "\(data.mostUsed)\(data.differentEmojisCount > 4 ? "+" : "") \(data.countString)"
            }
        }
        .onChange(of: message.reactions){
            if !message.reactions.isEmpty {
                reactionData = genReactions()
                guard let data = reactionData else { return }
                reactionContainer = "\(data.mostUsed)\(data.differentEmojisCount > 4 ? "+" : "") \(data.countString)"
            }
            else {
                reactionContainer = ""
                reactionData = nil
            }
        }
    }
    
    //MARK: - Parameters
    @State var reactionContainer: String = ""
    @ObservedRealmObject var message: Message
    @Binding var bottomCardReaction: BuiltReactions?
    @Binding var showStickerDetail: Bool
    let opaque = true //TODO: Find when its false
    @State var reactionData: BuiltReactions? = nil
    
    //MARK: - Initializer
    
    //MARK: -
}

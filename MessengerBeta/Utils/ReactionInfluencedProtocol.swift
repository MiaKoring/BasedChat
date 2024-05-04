import Foundation
import SwiftUI

protocol ReactionInfluenced {
    associatedtype Content: View
    func formatText()-> Content
    func genReactions()-> Reaction
    var formattedChars: [FormattedChar] { get set }
    var message: Message { get set }
}

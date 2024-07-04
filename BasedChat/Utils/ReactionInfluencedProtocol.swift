import Foundation
import SwiftUI

protocol ReactionInfluenced {
    func genReactions()-> BuiltReactions
    var message: Message { get set }
}

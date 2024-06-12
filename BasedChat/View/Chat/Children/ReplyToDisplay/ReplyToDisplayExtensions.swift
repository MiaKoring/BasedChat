import SwiftUI
import SwiftData

extension ReplyToDisplayView {
    func getText()-> String {
        replyTo!.text.count > 150 ?
        "\(replyTo!.text.prefix(150).prefix(upTo: replyTo!.text.prefix(150).lastIndex(of: " ") ?? replyTo!.text.prefix(150).endIndex))..." :
        replyTo!.text
    }
}

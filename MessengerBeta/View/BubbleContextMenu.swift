import Foundation
import SwiftUI

struct BubbleContextMenu: View {
    let message: Message
    @Environment(\.modelContext) var context
    var body: some View {
        Text(DateHandler.formatBoth(message.time, lang: "de_DE"))
        Button(role: .destructive){
            context.delete(message)
        } label: {
            Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
        }
    }
}

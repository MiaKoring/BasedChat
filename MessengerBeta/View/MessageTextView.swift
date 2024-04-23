import Foundation
import SwiftUI

struct MessageTextView: View, ReactionInfluenced {
    var message: Message
    @Binding var reactionContainer: String
    @Binding var formattedChars: [FormattedChar]
    var body: some View {
        HStack{
            if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                Text(message.text)
                    .padding(.bottom, reactionContainer.isEmpty ? 0 : 14.5)
            }
            else{
                formatText()
                    .padding(.bottom, reactionContainer.isEmpty ? 0 : 14.5)
                    .onAppear(){
                        formattedChars = self.formatChars(message.text)
                    }
            }
        }
    }
}

import Foundation
import SwiftUI

struct MessageTextView: View, ReactionInfluenced {
    //MARK: - Body
    
    var body: some View {
        HStack {
            formatText()
                .padding(.bottom, reactionContainer.isEmpty ? 0 : 14.5)
        }
        .onAppear(){
            formattedChars = message.formattedChars.sorted(by: {$0.id < $1.id})
        }
    }
    
    //MARK: - Parameters
    
    var message: Message
    @Binding var reactionContainer: String
    @Binding var formattedChars: [FormattedChar]
    
    init(message: Message, reactionContainer: Binding<String>, formattedChars: Binding<[FormattedChar]>) {
        self.message = message
        self._reactionContainer = reactionContainer
        self._formattedChars = formattedChars
    }
    
    //MARK: -
}

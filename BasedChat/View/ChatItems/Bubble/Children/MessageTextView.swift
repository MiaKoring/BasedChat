import Foundation
import SwiftUI
import RealmSwift

struct MessageTextView: View, TextFormatter {    
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            formatText()
                .padding(.bottom, reactionContainer.isEmpty ? 0 : 14.5)
        }
    }
    
    //MARK: - Parameters
    @ObservedRealmObject var message: Message
    @State var reactionContainer: String
    
    //MARK: -
}

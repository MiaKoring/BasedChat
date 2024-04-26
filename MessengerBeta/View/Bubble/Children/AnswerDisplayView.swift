import Foundation
import SwiftUI

public struct AnswerDisplayView: View {
    //MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text(senderName)
                .bold()
                .font(.system(size: 14))
            Text(text.count > 150 ? "\(text.prefix(150).prefix(upTo: text.prefix(150).lastIndex(of: " ") ?? text.prefix(150).endIndex))..." : text)
                .font(.system(size: 12))
        }
        .padding(3)
    }
    
    //MARK: - Parameters
    
    @State var text: String
    @State var senderName: String
    @State var originMessageID: UUID
    
    //MARK: -
}

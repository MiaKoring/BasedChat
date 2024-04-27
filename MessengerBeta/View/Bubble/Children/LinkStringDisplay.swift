import Foundation
import SwiftUI

struct LinkStringDisplay: View {
    let messageText: String
    let url: String?
    var body: some View {
        HStack{
            ZStack(alignment: .leading){
                MatchWidthView(text: messageText)
                Text(String(URL(string: url ?? "invalid URL")?.host() ?? "No URL"))//
                    .padding(5)
            }
        }
        .messageExtrasBackground()
    }
}

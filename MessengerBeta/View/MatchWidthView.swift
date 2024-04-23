import Foundation
import SwiftUI

struct MatchWidthView: View {
    let text: String
    var body: some View {
        ScrollView{
            Text(text)
        }
        .frame(maxHeight: 5)
        .hidden()
    }
}

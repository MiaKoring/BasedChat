import Foundation
import SwiftUI
import SwiftChameleon

struct MatchWidthView: View {
    let text: String
    let width: Double?
    
    init(text: String, width: Double? = nil) {
        self.text = text
        self.width = width
    }
    
    var body: some View {
        if width.isNil {
            ScrollView {
                Text(text)
            }
            .frame(maxHeight: 5)
            .hidden()
        }
        else {
            VStack{ }
                .frame(width: width!)
                .frame(maxHeight: 5)
        }
    }
}

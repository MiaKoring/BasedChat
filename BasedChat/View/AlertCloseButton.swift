import SwiftUI

struct AlertCloseButton: View {
    var body: some View {
        Button {
            displayed = false
        } label: {
            Text(text)
        }
    }
    
    var text: String = "OK"
    @Binding var displayed: Bool
}

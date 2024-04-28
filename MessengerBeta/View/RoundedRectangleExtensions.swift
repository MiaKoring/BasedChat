import SwiftUI

extension RoundedRectangle {
    func pullbarStyle()-> some View {
        self
            .fill(.gray)
            .opacity(0.7)
            .frame(width: 50, height: 5)
            .padding()
    }
}

import SwiftUI

extension TextField {
    func messageInputStyle()-> some View {
        self
            .padding(5)
            .lineLimit(3)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).fill(.ultraThickMaterial).allowsHitTesting(false))
            .padding(.horizontal, 5)
            .padding(.vertical, 4)
    }
}

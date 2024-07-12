import SwiftUI

struct PlusButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.gray.opacity(0.4))
            .frame(width: width, height: width)
            .overlay {
                Image(systemName: "plus")
                    .font(.title)
                    .allowsHitTesting(false)
            }
    }
    var width: CGFloat
}

import SwiftUI

struct DefaultBackground: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        switch colorScheme {
            case .light:
                LinearGradient(colors: [.meMSG.mix(with: .black, by: 0.1),.youMSG.mix(with: .black, by: 0.1)], startPoint: .leading, endPoint: .trailing)
            case .dark:
                LinearGradient(colors: [.meMSG.mix(with: .black, by: 0.1),.youMSG.mix(with: .white, by: 0.1)], startPoint: .leading, endPoint: .trailing)
            @unknown default:
                LinearGradient(colors: [.meMSG.mix(with: .black, by: 0.1),.youMSG.mix(with: .white, by: 0.1)], startPoint: .leading, endPoint: .trailing)
        }
    }
}

#Preview {
    DefaultBackground()
}

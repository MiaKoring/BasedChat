import SwiftUI

struct TopTabView: View {
    @State var selected: StickersheetContentType = .sticker
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TopTabButton(selected: $selected, image: .custom("GIF.bold"), imageFont: .title2, id: .gif)
                Divider()
                TopTabButton(selected: $selected, image: .custom("sticker.bold"), imageFont: .title2, id: .sticker)
            }
            .frame(height: 31)
            .padding(5)
            .background {
                RoundedRectangle(cornerRadius: 7)
                    .fill(.ultraThickMaterial)
            }
            switch selected {
                case .gif:
                    Text("GIF")
                case .sticker:
                    Text("Sticker")
            }
            Spacer()
        }
        .padding(.top, 30)
    }
}

import SwiftUI
import SwiftData

///Shows Stickers and GIFs in Chat(sheet)
struct TopTabView: View {
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        showSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18))
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .padding(.leading, 20)
                HStack {
                    TopTabButton(selected: $selected, image: .custom("GIF.bold"), imageFont: .system(size: 18), id: .gif)
                    Divider()
                    TopTabButton(selected: $selected, image: .custom("sticker.bold"), imageFont: .system(size: 18), id: .sticker)
                }
                .frame(height: 31)
                .padding(5)
                .background {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.ultraThickMaterial)
                        .shadow(radius: 6)
                }
            }
            switch selected {
                case .gif:
                    Text("GIF")
                case .sticker:
                    StickerSheet()
            }
            Spacer()
        }
        .padding(.top, 30)
        .sheet(isPresented: $showSearch) {
            VStack{
                switch selected {
                    case .gif:
                        Text("GIF")
                    case .sticker:
                        StickerSearch(stickerPath: $stickerPath, sendSticker: $sendSticker, showParentSheet: $showSearch)
                }
            }
            .padding(20)
        }
    }
    
    //MARK: - Parameters
    @State var selected: StickersheetContentType = .sticker
    @State var showSearch: Bool = false
    @Binding var stickerPath: String
    @Binding var sendSticker: Bool
}

#Preview {
    @Previewable @State var stickerPath = ""
    @Previewable @State var sendSticker = false
    TopTabView(stickerPath: $stickerPath, sendSticker: $sendSticker)
}

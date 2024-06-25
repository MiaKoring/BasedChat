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
                    TopTabButton(selected: $selected, id: .gif, image: .custom("GIF.bold"), imageFont: .system(size: 18))
                    Divider()
                    TopTabButton(selected: $selected, id: .sticker, image: .custom("sticker.bold"), imageFont: .system(size: 18))
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
                default:
                    Text("how did we get here") // shouldn't be possible
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
                        StickerSearch(showParentSheet: $showSearch, stickerPath: $stickerPath, sendSticker: $sendSticker, stickerName: $stickerName, stickerType: $stickerType)
                    default:
                        Text("How did we get here") // shouldn't be possible
                }
            }
            .padding(20)
            .presentationBackground(.thickMaterial)
        }
    }
    
    //MARK: - Parameters
    @State var selected: TopTabContentType = .sticker
    @State var showSearch: Bool = false
    @Binding var stickerPath: String
    @Binding var sendSticker: Bool
    @Binding var stickerName: String
    @Binding var stickerType: String
}

#Preview {
    @Previewable @State var stickerPath = ""
    @Previewable @State var sendSticker = false
    @Previewable @State var stickerName = ""
    @Previewable @State var stickerType = ""
    TopTabView(stickerPath: $stickerPath, sendSticker: $sendSticker, stickerName: $stickerName, stickerType: $stickerType)
}

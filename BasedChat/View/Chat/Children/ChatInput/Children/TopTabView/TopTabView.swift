import SwiftUI

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
                        StickerSearch(showParentSheet: $showSearch, sendSticker: $sendSticker)
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
    @Binding var sendSticker: SendableSticker
}

#Preview {
    @Previewable @State var sendSticker = SendableSticker(name: "", hash: "", type: "")
    TopTabView(sendSticker: $sendSticker)
}

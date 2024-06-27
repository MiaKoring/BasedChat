import RealmSwift
import SwiftUI

struct StickerDetailSheet: View {
    
    //MARK: - Body
    var body: some View {
        VStack{
#if canImport(UIKit)
            RoundedRectangle(cornerRadius: 25)
                .pullbarStyle()
#else
            HStack{
                CloseOnlyButtons(presented: $stickerSheetPresented)
                Spacer()
            }
#endif
            Spacer()
            StickerImageView(name: message.stickerHash, fileExtension: message.stickerType, data: $data, width: 200, height: 200, durationFactor: 30)
            List {
                Button {
                    if !removeFromFavourites() {
                        addToFavourites()
                    }
                } label: {
                    Label("Add to Favourites", systemImage: favourites.stickers.contains(where: {$0.hashString == message.stickerHash}) ? "star.fill" : "star")
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
        .alert("Couldn't find sticker", isPresented: $showAddStickerError) {
            Button(role: .cancel) {
            } label: {
                Text("OK")
            }
        }
    }
    
    //MARK: - Parameters
    @Binding var stickerSheetPresented: Bool
    @ObservedRealmObject var message: Message
    @Binding var data: Data?
    @State var showAddStickerError: Bool = false
    @ObservedRealmObject var favourites: StickerCollection
}

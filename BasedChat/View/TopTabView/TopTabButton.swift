import SwiftUI

struct TopTabButton: View {
    @Binding var selected: StickersheetContentType
    let image: TypedImage
    let imageFont: Font
    let id: StickersheetContentType
    var body: some View {
        Button { selected = id } label: {
            switch image {
                case .custom(let name):
                    Image(name)
                        .font(imageFont)
                case .system(let name):
                    Image(name)
                        .font(imageFont)
            }
                
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 35, height: 25 )
        .padding(3)
        .background {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(selected == id ? Color.gray : Color.clear)
        }
    }
}

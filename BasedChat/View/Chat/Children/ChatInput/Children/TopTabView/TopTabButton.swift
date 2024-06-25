import SwiftUI

struct TopTabButton: View {
    
    //MARK: - Body
    var body: some View {
        Button { selected = id } label: {
            switch image {
                case .custom(let name):
                    Image(name)
                        .font(imageFont)
                case .system(let name):
                    Image(systemName: name)
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
    
    //MARK: - Parameters
    @Binding var selected: TopTabContentType
    let id: TopTabContentType
    let image: TypedImage
    let imageFont: Font
}

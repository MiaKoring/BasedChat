import SwiftUI

struct CallButtonsView: View {
    
    //MARK: - Body
    
    var body: some View {
        Button {
            //TODO: add video call
        } label: {
            Image(systemName: "video")
                .font(.system(size: 24))
                .frame(width: 35, height: 35)
        }
        .buttonStyle(.plain)
        Button {
            //TODO: add voice call
        } label: {
            Image(systemName: "phone")
                .font(.system(size: 24))
                .frame(width: 35, height: 35)
        }
        .buttonStyle(.plain)
    }
    
    //MARK: - Parameters
    @State var showCallPopover: Bool = false
    
}

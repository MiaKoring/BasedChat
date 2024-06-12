import SwiftUI

struct CallButtonsView: View {
    
    //MARK: - Body
    
    var body: some View {
        Button {
            // TODO: add voicecall feature
        } label: {
            Image(systemName: "video")
                .font(.title2)
                .frame(width: 35, height: 35)
        }
        .buttonStyle(.plain)
        Button {
            // TODO: add videocall feature
        } label: {
            Image(systemName: "phone")
                .font(.title2)
                .frame(width: 35, height: 35)
        }
        .buttonStyle(.plain)
    }
    
    //MARK: - Parameters
    
    
}

import SwiftUI
import Foundation

struct TopBarButtonView: View {
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    switch showNavigation {
                        case .all:
                            showNavigation = .detailOnly
                            break
                        default:
                            showNavigation = .all
                    }
                }
            } label: {
                Image(systemName: "sidebar.left")
                    .font(.system(size: 24))
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(.plain)
            Spacer()
            CallButtonsView()
        }
    }
    
    //MARK: - Parameters
    
    @Binding var showNavigation: NavigationSplitViewVisibility
}

import Foundation
import SwiftUI

struct ChatTopBar: View {
    
    //MARK: - Body
    var body: some View {
        VStack {
            ZStack{
                #if canImport(UIKit)
                if UIDevice.isIPhone {
                    IOSTopBarButtonView()
                }
                else {
                    TopBarButtonView(showNavigation: $showNavigation)
                }
                #else
                TopBarButtonView(showNavigation: $showNavigation)
                #endif
                HStack {
                    Text("Elijah Franzen langer Text Test")
                        .lineLimit(1)
                        .bold()
                        .overlay(alignment: .leading) {
                            Image("TalkingCat")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 35, height: 35)
                                .offset(x: -50)
                        }
                }
                .padding(.horizontal, 100)
            }
            .frame(maxWidth: 550)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
    }
    
    //MARK: - Parameters
    @Binding var showNavigation: NavigationSplitViewVisibility
}

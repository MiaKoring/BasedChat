import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension View {
    func messageExtrasBackground()-> some View {
        self
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .fill(.gray)
                    .opacity(0.5)
            }
    }
    
    func bubbleBackground(isCurrent: Bool, background: String = "default", show: Bool = true)-> some View {
        if show {
            if isCurrent {
                return self
                    .background{
                        UnevenRoundedRectangle(
                            cornerRadii: .init(topLeading: 10, bottomLeading: 10, bottomTrailing: 2, topTrailing: 10))
                        .fill(background == "default" ? Color.init("MeMSG") : .gray)
                        .opacity(1)
                    }
            }
            return self
                .background{
                    UnevenRoundedRectangle(
                        cornerRadii: .init(topLeading: 10, bottomLeading: 2, bottomTrailing: 10, topTrailing: 10))
                        .fill(background == "default" ? Color.init("YouMSG") : .gray)
                        .opacity(1)
                }
        }
        return self
            .background(){
                UnevenRoundedRectangle
                    .rect(
                        cornerRadii: RectangleCornerRadii(topLeading: 10, bottomLeading: 2, bottomTrailing: 10, topTrailing: 10)
                    )
                    .fill(background == "default" ? Color.init("YouMSG") : .gray)
                    .opacity(0)
            }
    }

    func hideKeyboard()-> Void {
        DispatchQueue.main.async {
#if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
        }
    }
    
    func thinClearBackground(clear: Bool) -> some View {
        if clear {
            return self.background {
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .fill(.thinMaterial)
                    .opacity(0)
            }
        }
        return self.background {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(.thinMaterial)
                .opacity(1)
        }
    }
    
    func ignoresSafeAreaWith(condition: Bool, regions: SafeAreaRegions, edges: Edge.Set)-> some View {
        if condition {
            return AnyView(self.ignoresSafeArea(regions, edges: edges))
        }
        return AnyView(self)
    }
    
    @ViewBuilder
    func contactPicture() -> some View {
        if let image = self as? Image {
            image
                .resizable()
                .clipShape(Circle())
                .frame(width: 35, height: 35)
                .offset(x: -50)
        }
        else {
            self
                .frame(width: 35, height: 35)
                .offset(x: -50)
        }
    }
    
    func messageInputStyle()-> some View {
        self
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).fill(.ultraThickMaterial).allowsHitTesting(false))
            .padding(.horizontal, 5)
            .padding(.vertical, 4)
    }
}

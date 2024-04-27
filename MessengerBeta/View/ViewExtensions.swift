import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension View{
    func messageExtrasBackground() -> some View{
        self
            .background{
                RoundedRectangle(cornerRadius: 5)
                    .fill(.gray)
                    .opacity(0.5)
            }
    }
    func bubbleBackground(isCurrent: Bool, background: String = "default") -> some View{
        if isCurrent{
            return self
                .background(
                    UnevenRoundedRectangle
                        .rect(
                            cornerRadii: RectangleCornerRadii(topLeading: 10, bottomLeading: 10, bottomTrailing: 2, topTrailing: 10)
                        )
                        .fill(background == "default" ? Color.init("MeMSG") : .gray)
                )
        }
        return self
            .background(
                UnevenRoundedRectangle
                    .rect(
                        cornerRadii: RectangleCornerRadii(topLeading: 10, bottomLeading: 2, bottomTrailing: 10, topTrailing: 10)
                    )
                    .fill(background == "default" ? Color.init("YouMSG") : .gray)
            )
        
    }

    func hideKeyboard()->Void{
        #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }

}
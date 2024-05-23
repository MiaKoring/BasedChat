import Foundation
import SwiftUI

struct CloseOnlyButtons: View {
    //MARK: - Body
    
    var body: some View {
        HStack(spacing: 8.0) {
            Circle()
                .fill(.red)
                .frame(width: 12, height: 12)
                .overlay {
                    if hovered {
                        Image(systemName: "xmark")
                            .font(.system(size: 8, weight: .bold))
                            .allowsHitTesting(false)
                            .foregroundStyle(.thickMaterial)
                    }
                }
                .onTapGesture {
                    presented = false
                }
            Circle()
                .fill(Color("InactiveWindowButton"))
                .frame(width: 12, height: 12)
            Circle()
                .fill(Color("InactiveWindowButton"))
                .frame(width: 12, height: 12)
        }
        .onHover(perform: { hovering in
            hovered = hovering
        })
        .padding(.top, 10)
        .padding(.leading, 10)
    }
    
    //MARK: - Parameters
    
    @Binding var presented: Bool
    @State var hovered: Bool = false
}

import Foundation
import SwiftUI

extension Image {
    func commandImage(imageSize: CommandImageSize)-> some View {
        switch imageSize {
        case .detail:
            return self
                .scaleToFit()
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 11.2, style: .continuous))
                .padding(.horizontal, 10)
        case .list:
            return self
                .scaleToFit()
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.horizontal, 10)
        }
        
    }
    
    func scaleToFit()-> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

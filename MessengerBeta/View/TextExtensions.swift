//
//  TextExtensions.swift
//  MessengerBeta
//
//  Created by Mia Koring on 23.04.24.
//

import Foundation
import SwiftUI

extension Text {
    func reactionDisplayStyle(bottomCardReaction: Binding<Reaction?>, reactionData: Reaction, bottomCardOpen: Binding<Bool>, senderIsCurrent: Bool)-> some View {
        return self
            .font(.custom("JetBrainsMono-Regular", size: 13))
            .padding([.bottom,.leading,.top] , 2.5)
            .padding(.trailing, 4)
            .allowsHitTesting(false)
            .background() {
                UnevenRoundedRectangle
                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: senderIsCurrent ? 10 : 5, bottomTrailing: senderIsCurrent ? 5 : 10, topTrailing: 5))
                    .fill(senderIsCurrent ? Color.init("ReactionDisplayMe") : Color.init("ReactionDisplay"))
                    .onTapGesture {
                        bottomCardReaction.wrappedValue = reactionData
                        bottomCardOpen.wrappedValue.toggle()
                    }
            }
    }
    
    func boldSubheadline()-> some View {
        self
            .font(.subheadline)
            .bold()
    }
    
    func commandOwnerStyle()-> some View {
        self
        .padding(3)
        .bold()
        .font(.footnote)
        .background(){
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.thinMaterial)
        }
        .padding(.horizontal, 5)
        .allowsHitTesting(false)
    }
}


//
//  TextExtensions.swift
//  MessengerBeta
//
//  Created by Mia Koring on 23.04.24.
//

import Foundation
import SwiftUI

extension Text{
    func reactionDisplayStyle(bottomCardReaction: Binding<Reaction?>, reactionData: Reaction, bottomCardOpen: Binding<Bool>, senderIsCurrent: Bool)-> some View{
        return self
            .font(.custom("JetBrainsMono-Regular", size: 13))
            .padding([.bottom,.leading,.top] , 2.5)
            .padding(.trailing, 4)
            .background(){
                UnevenRoundedRectangle
                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 10, bottomTrailing: 5, topTrailing: 5))
                    .fill(senderIsCurrent ? Color.init("ReactionDisplayMe") : Color.init("ReactionDisplay"))
            }
            .onTapGesture {
                bottomCardReaction.wrappedValue = reactionData
                bottomCardOpen.wrappedValue.toggle()
            }
    }
}


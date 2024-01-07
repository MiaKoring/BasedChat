//
//  ReactionsCard.swift
//  MessengerBeta
//
//  Created by Mia Koring on 07.01.24.
//

import SwiftUI

struct ReactionOverview: View {
    @State var showView: String = "overview"
    @Binding var reaction: Reaction
    @State var emojis: [String]
    @State var buttonTapped: [String: Bool] = [:]
    var body: some View {
        if showView == "overview"{
            VStack{
                ForEach(0..<emojis.count){index in
                    HStack{
                        Text(emojis[index])
                        Spacer()
                        Text(String(reaction.emojisCount[emojis[index]] ?? 0))
                            .font(.custom("JetBrainsMono-Regular", size: 16))
                    }
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.init(buttonTapped[emojis[index]] ?? false ? "BottomCardButtonClicked" : "BottomCardBackground"))
                    }
                    .onTapGesture {
                        buttonTapped[emojis[index]] = true
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                            showView = emojis[index]
                        }
                    }
                    if index+1 != emojis.count{
                        Divider()
                    }
                }
            }
            .padding(15)
            .onAppear(){
                for i in 0..<emojis.count{
                    buttonTapped[emojis[i]] = false
                }
            }
        }
        else if showView != ""{
            SpecificReaction(relevantUsers: reaction.peopleReactions.keys(forValue: showView), showView: $showView)
        }
    }
}

struct SpecificReaction: View {
    @State var relevantUsers: [String]
    @Binding var showView: String
    var body: some View {
        VStack{
            Button{
                showView = "overview"
            } label: {
                Label("", systemImage: "arrowshape.backward")
            }
            VStack{
                ForEach(0..<relevantUsers.count){index in
                    Text(relevantUsers[index])
                    if index+1 != relevantUsers.count{
                        Divider()
                    }
                }
            }
        }
    }
}

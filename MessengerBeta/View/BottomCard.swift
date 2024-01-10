//
//  BottomCard.swift
//  MessengerBeta
//
//  Created by Mia Koring on 07.01.24.
//

import SwiftUI
import SwiftData

struct BottomCard<Content: View>: View {
    @Environment(\.modelContext) var context
    @ViewBuilder let content: Content
    @Binding var isOpen: Bool
    @Query var chats: [Chat]
    
    @State var totalHeight: Double = 0
    
    @State var startHeight = 0.0
    @State var blockActualisation = false
    
    let maxHeight = UIScreen.main.bounds.height * 0.8
    let normalHeight = UIScreen.main.bounds.height * 0.5
    let fullOpenHeight = UIScreen.main.bounds.height * 0.6
    let toNormalHeight = UIScreen.main.bounds.height * 0.7
    let closeHeight = UIScreen.main.bounds.height * 0.3
    
    var body: some View {
        VStack{
            HStack{
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 100, height: 5)
                    .padding(15)
            }
            .background(Color.init("BottomCardBackground"))
            .gesture(
                DragGesture()
                    .onChanged{value in
                        if !blockActualisation{
                            startHeight = totalHeight
                            blockActualisation = true
                        }
                        let newHeight = self.totalHeight - value.translation.height
                        totalHeight = max(100, min(newHeight, maxHeight))
                    }
                    .onEnded{_ in
                        blockActualisation = false
                        if totalHeight < closeHeight{
                            withAnimation(.easeOut(duration: 0.2)){
                                totalHeight = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                isOpen = false
                            }
                        }
                        else if startHeight == maxHeight{
                            if totalHeight < toNormalHeight {
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = normalHeight
                                }
                            }
                            else{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = maxHeight
                                }
                            }
                        }
                        else if startHeight == normalHeight{
                            if totalHeight > fullOpenHeight{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = maxHeight
                                }
                            }
                            else if totalHeight > normalHeight && totalHeight <= fullOpenHeight{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = normalHeight
                                }
                            }
                            else if totalHeight >= closeHeight{
                                withAnimation(.easeIn(duration: 0.2)){
                                    totalHeight = normalHeight
                                }
                            }
                        }
                        
                    }
            )
            
            ScrollView{
                Button(){
                    for _ in 0...100{
                        context.insert(Message(chatMessagesID:  chats.first!.messagesID, time: 1392642469, sender: "me", text: "testMessage"))
                    }
                    print("created")
                }label: {
                    Text("add message")
                }
                content
            }
        }
        .onAppear(){
            withAnimation(.easeIn(duration: 0.3)){
                totalHeight = UIScreen.main.bounds.height * 0.5
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: totalHeight)
        .background{
            UnevenRoundedRectangle
                .rect(cornerRadii: RectangleCornerRadii(topLeading: 25, topTrailing: 25))
                .fill(Color.init("BottomCardBackground"))
        }
        .onChange(of: isOpen){
            if isOpen{
                totalHeight = 0
                withAnimation(.easeIn(duration: 0.5)){
                    totalHeight = UIScreen.main.bounds.height * 0.5
                }
            }
            else{
                withAnimation(.easeOut(duration: 0.5)){
                    totalHeight = 0
                }
            }
        }
    }
}

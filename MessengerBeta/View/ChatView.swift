//
//  ChatView.swift
//  MessengerBeta
//
//  Created by Mia Koring on 07.01.24.
//

import SwiftUI

/*struct ChatView: View {
    @State var bottomCardOpen = false
    @State var bottomCardReaction: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @State var scrollTo = UUID()
    @Binding var messages: [Message]
    @State var triggerScroll = false
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{proxy in
                    LazyVStack(spacing: 8){
                        ForEach(0..<messages.count){ index in
                            if index == 0{
                                HStack{
                                    Spacer()
                                    Text(messages[index].time.split(separator: " ")[0])
                                        .font(Font.custom("JetBrainsMono-Regular", size: 12))
                                        .padding(2)
                                    Spacer()
                                }
                                .background(){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.init("DateDisplay"))
                                }
                                .onChange(of: triggerScroll){
                                    if triggerScroll{
                                        withAnimation(.easeIn(duration: 0.15)){
                                            proxy.scrollTo(scrollTo, anchor: .top)
                                        }
                                        triggerScroll.toggle()
                                    }
                                }
                            }
                            if messages[index].sender == "me" {
                                MeMSG(message: $messages[index], pos: index-1 < 0 || messages[index-1].sender != messages[index].sender || messages[index - 1].time.split(separator: " ")[0] !=  messages[index].time.split(separator: " ")[0]  ? "top" : "bottom", nextTime: index + 1 < messages.count && messages[index+1].sender == messages[index].sender ? messages[index + 1].time : nil, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
                                    .padding(.top, index - 1 >= 0 && messages[index].sender != messages[index-1].sender ? 4 : 0)
                                    .id(messages[index].id)
                            }
                            else{
                                YouMSG(message: $messages[index], pos: index-1 < 0 || messages[index-1].sender == "me" ? "top" : "bottom", nextTime: index + 1 < messages.count && messages[index+1].sender == messages[index].sender ? messages[index + 1].time : nil, bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
                                    .padding(.top, index - 1 >= 0 && messages[index].sender != messages[index-1].sender ? 4 : 0)
                                    .id(messages[index].id)
                            }
                            if index + 1 < messages.count && messages[index].time.split(separator: " ")[0] != messages[index + 1].time.split(separator: " ")[0]{
                                HStack{
                                    Spacer()
                                    Text(messages[index + 1].time.split(separator: " ")[0])
                                        .font(Font.custom("JetBrainsMono-Regular", size: 12))
                                        .padding(2)
                                    Spacer()
                                }
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.init("DateDisplay"))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .defaultScrollAnchor(.bottom)
            .padding(.top, 1)
            .padding(.bottom, 40)
            
            if(bottomCardOpen){
                BottomCard(content: {ReactionOverview(reaction: $bottomCardReaction, emojis: Array(bottomCardReaction.emojisCount.keys))}, isOpen: $bottomCardOpen)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}*/




struct ChatViewTest: View {
    @State var bottomCardOpen = false
    @State var bottomCardReaction: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @State var scrollTo = UUID()
    @Binding var messages: [Message]
    @State var triggerScroll = false
    @State var msg = Message(time: "", sender: "", text: "")
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{proxy in
                    LazyVStack(spacing: 8){
                        if messages.count > 0{
                            HStack{
                                Spacer()
                                Text(messages[0].time.split(separator: " ")[0])
                                    .font(Font.custom("JetBrainsMono-Regular", size: 12))
                                    .padding(2)
                                Spacer()
                            }
                            .background(){
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.init("DateDisplay"))
                            }
                            .onChange(of: triggerScroll){
                                if triggerScroll{
                                    withAnimation(.easeIn(duration: 0.15)){
                                        proxy.scrollTo(scrollTo, anchor: .top)
                                    }
                                    triggerScroll.toggle()
                                }
                            }
                        }
                        ForEach($messages, id: \.id){ message in
                            if message.sender.wrappedValue == "me" {
                                MeMSG(message: message, pos: "", nextTime: "", bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
                                    .padding(4)
                            }
                            else{
                                YouMSG(message: message, pos: "", nextTime: "", bottomCardOpen: $bottomCardOpen, bottomCardReaction: $bottomCardReaction, scrollTo: $scrollTo, messages: $messages, triggerScroll: $triggerScroll)
                                    .padding(.top, 4)
                                    .id(message.id)
                            }
                            if true{
                                HStack{
                                    Spacer()
                                    Text(message.time.split(separator: " ")[0])
                                        .font(Font.custom("JetBrainsMono-Regular", size: 12))
                                        .padding(2)
                                    Spacer()
                                }
                                .background{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.init("DateDisplay"))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .defaultScrollAnchor(.bottom)
            .padding(.top, 1)
            .padding(.bottom, 40)
            
            if(bottomCardOpen){
                BottomCard(content: {ReactionOverview(reaction: $bottomCardReaction, emojis: Array(bottomCardReaction.emojisCount.keys))}, isOpen: $bottomCardOpen)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

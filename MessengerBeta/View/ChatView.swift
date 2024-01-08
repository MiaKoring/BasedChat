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




struct ChatView: View {
    @State var bottomCardOpen = false
    @State var bottomCardReaction: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @State var scrollTo = UUID()
    @State var messages: [Message]
    @State var triggerScroll = false
    @State var msg = Message(time: "", sender: "", text: "")
    @State var lastTime = ""
    @State var previousMessage: Message? = nil
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView{
                ScrollViewReader{proxy in
                    LazyVStack(spacing: 8){

                        ForEach($messages) { $message in
                            if $message.time.wrappedValue.split(separator: " ")[0] != ($messages.firstIndex(where: {$0.id == message.id}) != $messages.startIndex ? $messages[messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].time.wrappedValue.split(separator: " ")[0] : ""){
                                HStack{
                                    Spacer()
                                    Text($message.time.wrappedValue.split(separator: " ")[0])
                                        .font(Font.custom("JetBrainsMono-Regular", size: 12))
                                        .padding(2)
                                    Spacer()
                                }
                                .background(){
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.init("DateDisplay"))
                                }
                                
                            }
                            if $message.sender.wrappedValue == "me" {
                                MeMSG(
                                    message: $message,
                                    pos: $messages.firstIndex(where: {$0.id == message.id}) != $messages.startIndex ? ($messages[$messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].sender.wrappedValue == message.sender && $messages[$messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].time.wrappedValue.split(separator: " ")[0] == message.time.split(separator: " ")[0] ? "bottom" : "top") : "",
                                    nextTime: nil,
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    messages: $messages,
                                    triggerScroll: $triggerScroll,
                                    showTime: $messages.indices.contains($messages.index(after: $messages.firstIndex(where: {$0.id == message.id}) ?? -1)) && $messages[$messages.index(after: $messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].sender.wrappedValue == $message.sender.wrappedValue ?  ($messages[$messages.index(after: $messages.firstIndex(where: {$0.id == message.id}) ?? 0 )].time.wrappedValue != $message.time.wrappedValue) : true
                                )
                                .id(message.id)
                            }
                            else{
                                YouMSG(
                                    message: $message,
                                    pos: $messages.firstIndex(where: {$0.id == message.id}) != $messages.startIndex ? ($messages[$messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].sender.wrappedValue == message.sender && $messages[$messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].time.wrappedValue.split(separator: " ")[0] == message.time.split(separator: " ")[0] ? "bottom" : "top") : "",
                                    nextTime: nil,
                                    bottomCardOpen: $bottomCardOpen,
                                    bottomCardReaction: $bottomCardReaction,
                                    scrollTo: $scrollTo,
                                    messages: $messages,
                                    triggerScroll: $triggerScroll,
                                    showTime: $messages.indices.contains($messages.index(after: $messages.firstIndex(where: {$0.id == message.id}) ?? -1)) && $messages[$messages.index(after: $messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].sender.wrappedValue == $message.sender.wrappedValue ?  ($messages[$messages.index(after: $messages.firstIndex(where: {$0.id == message.id}) ?? 0 )].time.wrappedValue != $message.time.wrappedValue) : true
                                )
                                .id(message.id)
                            }
                        }
                    }
                    .onChange(of: triggerScroll){
                        if triggerScroll{
                            withAnimation(.easeIn(duration: 0.15)){
                                proxy.scrollTo(scrollTo, anchor: .top)
                            }
                            triggerScroll.toggle()
                        }
                    }
                    .onChange(of: messages){
                        print("item got deleted")
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

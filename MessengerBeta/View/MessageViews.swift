//
//  MessageViews.swift
//  MessengerBeta
//
//  Created by Mia Koring on 07.01.24.
//

import SwiftUI
import SwiftData

struct AnswerDisplay: View {
    @State var text: String
    @State var senderName: String
    @State var originMessageID: UUID
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text(senderName)
                .bold()
                .font(.system(size: 14))
            Text(text.count > 150 ? "\(text.prefix(150).prefix(upTo: text.prefix(150).lastIndex(of: " ") ?? text.prefix(150).endIndex))..." : text)
                .font(.system(size: 12))
        }
        .padding(3)
    }
}

struct MeMSG: View{
    @Environment(\.modelContext) var context
    var message: Message
    let pos: String
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction
    @State var reactionContainer = ""
    var reactionCount: Float = 0
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll: Bool
    @State var formattedChars: [FormattedChar] = []
    @Binding var glowOriginMessage: UUID?
    @Binding var messageToDelete: Message?
    
    var body: some View{
        VStack{
            HStack{
                Spacer(minLength: UIScreen.main.bounds.width*0.2)
                HStack{
                    ZStack(alignment: .bottomTrailing){
                        VStack(alignment: .leading){
                            if message.type == "reply" && !message.reply.isDeleted{
                                HStack{
                                    ZStack(alignment: .leading){
                                        Text(message.text)
                                            .frame(maxHeight: 5)
                                            .hidden()
                                        AnswerDisplay(text: message.reply.text, senderName: message.reply.sender, originMessageID: message.reply.originID)
                                    }
                                }
                                .onTapGesture {
                                    scrollTo = message.reply.originID
                                    triggerScroll.toggle()
                                    glowOriginMessage = message.reply.originID
                                }
                                .background{
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.gray)
                                        .opacity(0.5)
                                }
                            }
                            if !reactionContainer.isEmpty{
                                if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                    Text(message.text)
                                        .padding(.bottom, 14.5)
                                }
                                else{
                                    formatText()
                                        .padding(.bottom, 14.5)
                                        .onAppear(){
                                            formattedChars = formatChars(message.text)
                                        }
                                }
                            }
                            else{
                                if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                    Text(message.text)
                                }
                                else{
                                    formatText()
                                        .onAppear(){
                                            formattedChars = formatChars(message.text)
                                        }
                                }
                            }
                        }
                        .padding(10)
                        
                        Text(reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.trailing,.top] , 2.5)
                            .padding(.leading, 4)
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 10, bottomTrailing: 5, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplay"))
                            }
                            .hidden()
                        
                    }
                }
                .background(
                    UnevenRoundedRectangle
                        .rect(
                            cornerRadii: RectangleCornerRadii(topLeading: 10, bottomLeading: 10, bottomTrailing: 2, topTrailing: pos == "bottom" ? 2 : 10)
                        )
                        .fill(message.background == "normal" ? Color.init("MeMSG") : .gray)
                )
                .overlay(alignment: .bottomLeading, content: {
                    if !reactionContainer.isEmpty && Double(reactionContainer.count) * 1.2 <= Double(message.text.count){
                        Text(reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 10, bottomTrailing: 5, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                    
                    else if !reactionContainer.isEmpty{
                        Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 10, bottomTrailing: 5, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                })
                .contextMenu(){
                    Text(DateHandler.formatBoth(message.time, lang: "de_DE"))
                    Button(role: .destructive){
                        messageToDelete = message
                    } label: {
                        Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
                    }
                    
                }
            }
            .onAppear{
                if !message.reactions.isEmpty{
                    reactionData = genReactions()
                    reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
                }
            }
            
        }
        .background(Color.init("Background"))
    }

    
    func formatText()-> some View{
        var text = Text("")
        for i in 0..<formattedChars.count{
            if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic().strikethrough()
            }
            else if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && !formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic()
            }
            else if formattedChars[i].formats.contains("*") && !formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).strikethrough()
            }
            else if formattedChars[i].formats == ["*"] {
                text = text+Text(formattedChars[i].char).fontWeight(.bold)
            }
            else if !formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).italic().strikethrough()
            }
            else if formattedChars[i].formats == ["_"] {
                text = text+Text(formattedChars[i].char).italic()
            }
            else if formattedChars[i].formats == ["~"] {
                text = text+Text(formattedChars[i].char).strikethrough()
            }
            else{
                text = text + Text(formattedChars[i].char)
            }
        }
        return text
    }
    
    func formatChars(_ str: String) -> [FormattedChar] {
        var formattedChars: [FormattedChar] = []
        var currentChar = ""
        var previousChar = ""
        var currentFormats: [String] = []
        var blockAdding = false
        let input = str.replacingOccurrences(of: "\n", with: "￿")
        
        let allowedSurroundingChars = ["", " ", "￿", ".", ",", ":", ";", "\"", "'", "*", "_", "~"]
        for i in 0..<input.count {
            let atm =  String(input[input.index(input.startIndex, offsetBy: i)])
            
            let next = i + 1 < input.count ? String(input[input.index(input.startIndex, offsetBy: i+1)]) : ""
            if (atm == "*" || atm == "_" || atm == "~") && (allowedSurroundingChars.contains(previousChar) || allowedSurroundingChars.contains(next))  {
                    
                if !currentChar.isEmpty {
                    let formattedChar = FormattedChar(char: currentChar, formats: currentFormats)
                    formattedChars.append(formattedChar)
                    currentChar = ""
                    
                }
                if currentFormats.contains(String(atm)) && allowedSurroundingChars.contains(next){
                    currentFormats.removeAll(where: {$0 == String(atm)})
                    blockAdding = true
                }
                if !blockAdding && allowedSurroundingChars.contains(previousChar) {
                    currentFormats.append(String(atm))
                }
                else{
                    blockAdding = false
                }
            } else {
                currentChar.append(atm)
            }
            previousChar = atm
            
        }
        if !currentChar.isEmpty {
            let formattedChar = FormattedChar(char: currentChar.replacingOccurrences(of: "￿", with: "\n"), formats: currentFormats)
            formattedChars.append(formattedChar)
        }
        
        
        return formattedChars
    }
    func genReactions()-> Reaction{
        let differentEmojis = Array(Set(message.reactions.values))
        var emojisCount: [String : Int] = [:]
        var totalCount = 0.0
        var reactionCache = ""
        let differentEmojisCount = differentEmojis.count
        for i in 0 ..< differentEmojis.count{
            let countForEmoji = message.reactions.keys(forValue: differentEmojis[i]).count
            emojisCount[differentEmojis[i]] = countForEmoji
            totalCount += Double(countForEmoji)
        }
        let sortedByCount = Dictionary(uniqueKeysWithValues: emojisCount.sorted(by: {$0.value > $1.value}))
        let reactionList = Array(sortedByCount.keys)
        for i in 0 ..< sortedByCount.count {
            if (i < 4){
                reactionCache += reactionList[i]
            }
        }
        var countString = String(Int(totalCount))
        if totalCount > 1000{
            totalCount = totalCount / 1000
            totalCount = (totalCount*10).rounded()/10
            countString = String(totalCount)+"K"
        }
        return Reaction(mostUsed: reactionCache, countString: countString, emojisCount: emojisCount, differentEmojisCount: differentEmojisCount, peopleReactions: message.reactions)
    }
}



struct YouMSG: View{
    @Environment(\.modelContext) var context
    let message: Message
    let pos: String
    @Binding var bottomCardOpen: Bool
    @Binding var bottomCardReaction: Reaction
    @State var reactionContainer = ""
    var reactionCount: Float = 0
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var scrollTo: UUID?
    @Binding var triggerScroll: Bool
    @State var formattedChars: [FormattedChar] = []
    @Binding var glowOriginMessage: UUID?
    @Binding var messageToDelete: Message?
    
    var body: some View{
        VStack{
            HStack{
                ZStack(alignment: .bottomLeading){
                    VStack(){
                        if message.type == "reply"{
                            HStack{
                                ZStack(alignment: .leading){
                                    Text(message.text)
                                        .frame(maxHeight: 5)
                                        .hidden()
                                    AnswerDisplay(text: message.reply.text, senderName: message.reply.sender, originMessageID: message.reply.originID)
                                }
                            }
                            .onTapGesture {
                                scrollTo = message.reply.originID
                                triggerScroll.toggle()
                                glowOriginMessage = message.reply.originID
                            }
                            .background{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.gray)
                                    .opacity(0.5)
                            }
                        }
                        if !reactionContainer.isEmpty{
                            if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                Text(message.text)
                                    .padding(.bottom, 14.5)
                            }
                            else{
                                formatText()
                                    .padding(.bottom, 14.5)
                                    .onAppear(){
                                        formattedChars = formatChars(message.text)
                                    }
                            }
                        }
                        else{
                            if !message.text.contains("*") && !message.text.contains("_") && !message.text.contains("~"){
                                Text(message.text)
                            }
                            else{
                                formatText()
                                    .onAppear(){
                                        formattedChars = formatChars(message.text)
                                    }
                            }
                        }
                    }
                    .padding(10)
                    
    
                    Text(reactionContainer)
                        .font(.custom("JetBrainsMono-Regular", size: 13))
                        .padding([.bottom,.leading,.top] , 2.5)
                        .padding(.trailing, 4)
                        .background(){
                            UnevenRoundedRectangle
                                .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 5, bottomTrailing: 10, topTrailing: 5))
                                .fill(Color.init("ReactionDisplay"))
                        }
                        .hidden()
                    
                }
                .background(
                    UnevenRoundedRectangle
                        .rect(
                            cornerRadii: RectangleCornerRadii(topLeading: pos == "bottom" ? 2 : 10, bottomLeading: 2, bottomTrailing: 10, topTrailing: 10)
                        )
                        .fill(message.background == "normal" ? Color.init("YouMSG") : .gray)
                )
                .overlay(alignment: .bottomTrailing, content: {
                    if !reactionContainer.isEmpty && Double(reactionContainer.count) * 1.2 <= Double(message.text.count){
                        Text(reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 5, bottomTrailing: 10, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                    else if !reactionContainer.isEmpty{
                        Text(reactionContainer.split(separator: " ")[0].count > 1 ? "\(reactionContainer.split(separator: " ")[0].first!)+ \(reactionContainer.split(separator: " ")[1])" : reactionContainer)
                            .font(.custom("JetBrainsMono-Regular", size: 13))
                            .padding([.bottom,.leading,.top] , 2.5)
                            .padding(.trailing, 4)
                            .onTapGesture {
                                bottomCardReaction = reactionData
                                bottomCardOpen.toggle()
                            }
                            .background(){
                                UnevenRoundedRectangle
                                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 5, bottomLeading: 5, bottomTrailing: 10, topTrailing: 5))
                                    .fill(Color.init("ReactionDisplayMe"))
                            }
                    }
                })
                .contextMenu{
                    Button(role: .destructive){
                        messageToDelete = message
                    } label: {
                        Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
                    }
                }
                Spacer(minLength: UIScreen.main.bounds.width*0.2)
            }
            .onAppear{
                if !message.reactions.isEmpty{
                    reactionData = genReactions()
                    reactionContainer = "\(reactionData.mostUsed)\(reactionData.differentEmojisCount > 4 ? "+" : "")\(reactionData.countString == "0" ? "" : " \(reactionData.countString)")"
                }
            }
            
        }
        .background(Color.init("Background"))
    }
    func formatText()-> some View{
        var text = Text("")
        for i in 0..<formattedChars.count{
            if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic().strikethrough()
            }
            else if formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && !formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).italic()
            }
            else if formattedChars[i].formats.contains("*") && !formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).fontWeight(.bold).strikethrough()
            }
            else if formattedChars[i].formats == ["*"] {
                text = text+Text(formattedChars[i].char).fontWeight(.bold)
            }
            else if !formattedChars[i].formats.contains("*") && formattedChars[i].formats.contains("_") && formattedChars[i].formats.contains("~") {
                text = text+Text(formattedChars[i].char).italic().strikethrough()
            }
            else if formattedChars[i].formats == ["_"] {
                text = text+Text(formattedChars[i].char).italic()
            }
            else if formattedChars[i].formats == ["~"] {
                text = text+Text(formattedChars[i].char).strikethrough()
            }
            else{
                text = text + Text(formattedChars[i].char)
            }
        }
        return text
    }
    
    func formatChars(_ str: String) -> [FormattedChar] {
        var formattedChars: [FormattedChar] = []
        var currentChar = ""
        var previousChar = ""
        var currentFormats: [String] = []
        var blockAdding = false
        let input = str.replacingOccurrences(of: "\n", with: "￿")
        
        let allowedSurroundingChars = ["", " ", "￿", ".", ",", ":", ";", "\"", "'", "*", "_", "~"]
        for i in 0..<input.count {
            let atm =  String(input[input.index(input.startIndex, offsetBy: i)])
            
            let next = i + 1 < input.count ? String(input[input.index(input.startIndex, offsetBy: i+1)]) : ""
            if (atm == "*" || atm == "_" || atm == "~") && (allowedSurroundingChars.contains(previousChar) || allowedSurroundingChars.contains(next))  {
                    
                if !currentChar.isEmpty {
                    let formattedChar = FormattedChar(char: currentChar, formats: currentFormats)
                    formattedChars.append(formattedChar)
                    currentChar = ""
                    
                }
                if currentFormats.contains(String(atm)) && allowedSurroundingChars.contains(next){
                    currentFormats.removeAll(where: {$0 == String(atm)})
                    blockAdding = true
                }
                if !blockAdding && allowedSurroundingChars.contains(previousChar) {
                    currentFormats.append(String(atm))
                }
                else{
                    blockAdding = false
                }
            } else {
                currentChar.append(atm)
            }
            previousChar = atm
            
        }
        if !currentChar.isEmpty {
            let formattedChar = FormattedChar(char: currentChar.replacingOccurrences(of: "￿", with: "\n"), formats: currentFormats)
            formattedChars.append(formattedChar)
        }
        
        
        return formattedChars
    }
    func genReactions()-> Reaction{
        let differentEmojis = Array(Set(message.reactions.values))
        var emojisCount: [String : Int] = [:]
        var totalCount = 0.0
        var reactionCache = ""
        let differentEmojisCount = differentEmojis.count
        for i in 0 ..< differentEmojis.count{
            let countForEmoji = message.reactions.keys(forValue: differentEmojis[i]).count
            emojisCount[differentEmojis[i]] = countForEmoji
            totalCount += Double(countForEmoji)
        }
        let sortedByCount = Dictionary(uniqueKeysWithValues: emojisCount.sorted(by: {$0.value > $1.value}))
        let reactionList = Array(sortedByCount.keys)
        for i in 0 ..< sortedByCount.count {
            if (i < 4){
                reactionCache += reactionList[i]
            }
        }
        var countString = String(Int(totalCount))
        if totalCount > 1000{
            totalCount = totalCount / 1000
            totalCount = (totalCount*10).rounded()/10
            countString = String(totalCount)+"K"
        }
        return Reaction(mostUsed: reactionCache, countString: countString, emojisCount: emojisCount, differentEmojisCount: differentEmojisCount, peopleReactions: message.reactions)
    }
}


struct ReplyToDisplay: View {
    @Binding var replyTo : Reply?
    var body: some View {
        if replyTo != nil{
            VStack(alignment: .leading, spacing: 5){
                Text(replyTo!.sender)
                    .bold()
                    .font(.system(size: 14))
                Text(replyTo!.text.count > 150 ? "\(replyTo!.text.prefix(150).prefix(upTo: replyTo!.text.prefix(150).lastIndex(of: " ") ?? replyTo!.text.prefix(150).endIndex))..." : replyTo!.text)
                    .font(.system(size: 12))
            }
            .padding(3)
        }
    }
}

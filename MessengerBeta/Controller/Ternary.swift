//
//  Ternary.swift
//  MessengerBeta
//
//  Created by Mia Koring on 09.01.24.
//

import Foundation

class Ternary{
    static func dateDivider(message: Message, messages: [Message])-> Bool{
        return DateHandler.formatDate(message.time, lang: "de_DE") != (messages.firstIndex(where: {$0.id == message.id}) != messages.startIndex ? DateHandler.formatDate(messages[messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].time, lang: "de_DE") : "")
    }
    static func pos(message: Message, messages: [Message])-> String{
        return messages.firstIndex(where: {$0.id == message.id}) != messages.startIndex ? (messages[messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].sender == message.sender && DateHandler.formatTime(messages[messages.index(before: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].time, lang: "de_DE") == DateHandler.formatTime(message.time, lang: "de_DE") ? "bottom" : "top") : ""
    }
    static func showTime(message: Message, messages: [Message])-> Bool{
        messages.indices.contains(messages.index(after: messages.firstIndex(where: {$0.id == message.id}) ?? -1)) && messages[messages.index(after: messages.firstIndex(where: {$0.id == message.id}) ?? 1 )].sender == message.sender ?  (DateHandler.formatTime(messages[messages.index(after: messages.firstIndex(where: {$0.id == message.id}) ?? 0 )].time, lang: "de_DE") != DateHandler.formatTime(message.time, lang: "de_DE")) : true
    }
}

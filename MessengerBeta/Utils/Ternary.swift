//
//  Ternary.swift
//  MessengerBeta
//
//  Created by Mia Koring on 09.01.24.
//

import Foundation

class Ternary{
    static func dateDivider(message: Message, messages: [Message])-> Bool{
        let indexAfter = messages.index(after: messages.firstIndex(of: message)!)
        if !messages.indices.contains(indexAfter){
            return true
        }
        if DateHandler.formatDate(messages[indexAfter].time, lang: "de_DE") != DateHandler.formatDate(message.time, lang: "de_DE"){
            return true
        }
        return false
    }
}

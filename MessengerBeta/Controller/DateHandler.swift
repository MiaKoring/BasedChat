//
//  DateHandler.swift
//  MessengerBeta
//
//  Created by Mia Koring on 09.01.24.
//

import Foundation

class DateHandler{
    static func formatDate(_ unixTimestamp: Int, lang: String)-> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: lang)
        
        return formatter.string(from: Date(timeIntervalSince1970: Double(unixTimestamp)))
    }
    
    static func formatTime(_ unixTimestamp: Int, lang: String)-> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: lang)
        
        return formatter.string(from: Date(timeIntervalSince1970: Double(unixTimestamp)))
    }
    static func formatBoth(_ unixTimestamp: Int, lang: String)-> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: lang)
        
        return formatter.string(from: Date(timeIntervalSince1970: Double(unixTimestamp)))
    }
}

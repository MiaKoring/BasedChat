//
//  Item.swift
//  MessengerBeta
//
//  Created by Mia Koring on 30.12.23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

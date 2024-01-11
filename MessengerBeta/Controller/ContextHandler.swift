//
//  ContextHandler.swift
//  MessengerBeta
//
//  Created by Mia Koring on 11.01.24.
//

import Foundation
import SwiftUI
import SwiftData

class ContextHandler{
    static func delete(model: any PersistentModel){
        @Environment(\.modelContext) var context
        context.delete(model)
    }
}

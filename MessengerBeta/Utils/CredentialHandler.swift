//
//  Credentials.swift
//  MessengerBeta
//
//  Created by Mia Koring on 22.04.24.
//

import Foundation
import KeychainAccess

final class CredentialHandler{
    public var keychain: Keychain
    public static var shared = CredentialHandler()
    
    init() {
        self.keychain = Keychain(service: "\(Bundle.main.bundleIdentifier ?? "de.touchthegrass.BasedChat").KeyChain")
    }
    
    public func saveCredentials(_ credentials: Credentials)-> Bool{
        do{
            self.keychain["\(credentials.userID)"] = try JSONEncoder().encode(credentials).base64EncodedString()
            return true
        } catch let error{
            print(error)
            return false
        }
    }
    
    public func getCredentialsFor(_ id: Int)-> Credentials?{
        do{
            if let res = self.keychain["\(id)"], let resData = Data(base64Encoded: res){
                return try JSONDecoder().decode(Credentials.self, from: resData)
            }
        } catch let error{
            print(error)
        }
        return nil
        
    }
    
}

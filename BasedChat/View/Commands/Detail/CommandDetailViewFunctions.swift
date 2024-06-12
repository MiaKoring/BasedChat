import Foundation
import SlashCommands
import SwiftUI

extension CommandDetailView {
    func paramTapped(_ param: CommandParameter) {
        currentParam = param
        if !setParams.contains(param.name) {
            if commandInput.last == " " {
                commandInput.append("\(param.name):")
                return
            }
            commandInput.append(" \(param.name):")
        }
    }
    
    func commandInputChanged() {
        if checkCommand() { return }
        
        handlePrefix()
        
        if currentCommand != nil && !currentCommand!.parameters.isEmpty {
            handleParams()
        }
    }
    
    fileprivate func checkCommand()-> Bool{
        if commandInput.first != "/" {
            currentCommand = nil
            relevantCommands = []
            return true
        }
        return false
    }
    
    fileprivate func suffixLastIndex()-> String.Index {
        if let index = commandInput.firstIndex(of: " ") {
            return commandInput.index(before: index)
        }
        return commandInput.index(before: commandInput.endIndex)
    }
    
    fileprivate func handlePrefix() {
        let lastIndex = suffixLastIndex()
        
        let commandprefix = String(commandInput[commandInput.startIndex...lastIndex])
        DispatchQueue.global(qos: .background).async {
            let relevant = collection.commands(for: commandprefix, highestPermission: .none)
            
            DispatchQueue.main.async {
                relevantCommands = relevant
            }
        }
        
        if commandprefix == "/" {
            currentCommand = nil
        }
        else if currentCommand != nil && commandprefix.dropFirst() != currentCommand!.command {
            prefixWrong = true
        }
        else {
            prefixWrong = false
        }
        
        if !relevantCommands.contains(where: {$0.command == currentCommand?.command && $0.commandOwner == currentCommand?.commandOwner}){
            currentCommand = nil
        }
    }
    
    fileprivate func handleParams() {
        DispatchQueue.global(qos: .background).async {
            let params = paramNames()
            
            DispatchQueue.main.async {
                setParams = params
                if !setParams.contains(currentParam?.name ?? ""){
                    currentParam = nil
                }
            }
        }
    }
    
    fileprivate func paramNames() -> [String] {
        do {
            let matches = try commandInput.matches(of: Regex(currentRegex!))
            var paramNames: [String] = []
            
            for match in matches {
                let name = commandInput[match.range].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ":", with: "")
                if paramNames.contains(name) {
                    commandValid = false
                    return []
                }
                paramNames.append(name)
            }
            return paramNames
        }
        catch {
            regexAlertShown = true
        }
        return []
    }
}

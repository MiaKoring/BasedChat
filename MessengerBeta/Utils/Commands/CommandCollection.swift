import Foundation

class CommandCollection {
    var commands: [Command]
    
    init(commands: [Command]) {
        self.commands = commands
    }
    
    ///returns all commands that start with the input
    public func commands(for string: String)-> [Command]{
        if string.contains("\n") { return [] }
        
        var cmdInput = string.dropFirst()
        
        if cmdInput.contains(" "){
            let spaceIndex = cmdInput.firstIndex(of: " ")!
            cmdInput = cmdInput[cmdInput.startIndex ... cmdInput.index(before: spaceIndex)]
        }
        
        return commands.filter({
            $0.command.starts(with: cmdInput)
        })
    }
    
    public func execute(_ command: Command, with string: String){
        var regex = genCommandRegex(for: command)
        do{
            var matchRanges = try matchRanges(for: string, with: regex)
            let matches = matches(from: string, for: matchRanges)
            let required = requiredParams(of: command.parameters)
            try checkRequiredExist(required, in: matches)
            let paramDictionary = try paramDictionary(for: matches, with: command.parameters)
            command.completion(paramDictionary)
        }
        catch let error{
            print(error)
        }
    }
    
    private func genCommandRegex(for command: Command)-> String {
        var closure = ""
        for i in 0 ..< command.parameters.count {
            closure += " \(command.parameters[i].name): "
            if i < command.parameters.count - 1 {
                closure += "|"
            }
        }
        return "(\(closure)).*?(?=\(closure)|$)"
    }
    
    private func matchRanges(for input: String, with regex: String)throws -> [Regex<AnyRegexOutput>.Match] {
        do{
            return try input.matches(of: Regex(regex))
        }
        catch{
            throw CommandError.regexFailed
        }
    }
    
    private func matches(from string: String, for range: [Regex<AnyRegexOutput>.Match])-> [String] {
        return range.map({matchRange in
            return string[matchRange.range].trimmingCharacters(in: .whitespacesAndNewlines)
        })
    }
    
    private func requiredParams(of params: [CommandParameter])-> [CommandParameter] {
        return params.compactMap{param in
            if param.required { return param }
            return nil
        }
    }
    
    private func checkRequiredExist(_ required: [CommandParameter], in matches: [String])throws {
        for require in required {
            if !matches.contains(where: {$0.starts(with: require.name)}){
                throw CommandError.missingParameter
            }
        }
    }
    
    private func paramValue(with type: CommandParameterDatatype, for valueString: String, named name: String)throws -> Any {
        switch type {
        case .int:
            guard let value = Int(valueString) else{
                throw CommandError.paramInvalidType(name)
            }
            return value
        case .string:
            return valueString
        case .double:
            guard let value = Double(valueString) else{
                throw CommandError.paramInvalidType(name)
            }
            return value
        case .bool:
            guard let value = Bool(valueString) else{
                throw CommandError.paramInvalidType(name)
            }
            return value
        }
    }
    
    private func paramDictionary(for matches: [String], with parameters: [CommandParameter])throws -> [String: Any] {
        var paramDictionary: [String: Any] = [:]
        for match in matches{
            let name = String(match[match.startIndex...match.index(before: match.firstIndex(of: ":")!)])
            print("\"\(name)\"")
            let type = parameters.first(where: {$0.name == name})!.datatype
            let valueString = String(match[match.index(match.firstIndex(of: ":")!, offsetBy: 2)..<match.endIndex])
            let value = try paramValue(with: type, for: valueString, named: name)
            paramDictionary[name] = value
        }
        return paramDictionary
    }
}

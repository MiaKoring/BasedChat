import Foundation
import SlashCommands

class Unflip: Command {
    var id: UUID = UUID()
    
    var command: String = "unflip"
    
    var description: String = "UnflipDescription"
    
    var parameters: [CommandParameter] = [
        CommandParameter(id: 0, name: "message", description: "MessageParamDescription", datatype: .string, required: false)
    ]
    
    var minPermissions: Permission = .none
    
    var commandOwner: String = "integrated"
    
    var completion: ([String : Any]) -> Void
    
    init(completion: @escaping ([String : Any]) -> Void) {
        self.completion = completion
    }
}

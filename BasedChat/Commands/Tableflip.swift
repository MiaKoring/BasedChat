import Foundation
import SlashCommands

class Tableflip: Command {
    var id: UUID = UUID()
    
    var userAccessible: Bool = true
    
    var command: String = "tableflip"
    
    var description: String = "TableFlipDescription"
    
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

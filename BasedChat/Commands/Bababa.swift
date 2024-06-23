import Foundation
import SlashCommands

class Bababa: Command {
    var userAccessible: Bool = true
    
    var id: UUID = UUID()
    
    var command: String = "bababa"
    
    var description: String = "BababaDescription"
    
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

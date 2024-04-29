import Foundation

protocol Command {
    var command: String { get }
    var parameters: [CommandParameter] { get }
    var minPermissions: Permission { get }
    var commandOwner: String { get }
    var completion: ([String: Any])-> Void { get }
}

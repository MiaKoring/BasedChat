import Foundation
import SwiftUI
import SlashCommands

struct CommandOwnerOverlayView: View {
    
    //MARK: - Body
    
    var body: some View {
        if command.commandOwner == "integrated" {
            Text(LocalizedStringKey("integrated"))
                .commandOwnerStyle()
        }
        else {
            Text(command.commandOwner.uppercased())
                .commandOwnerStyle()
        }
    }
    
    //MARK: - Params
    
    let command: any Command
    
    //MARK: -
}

import Foundation
import SwiftUI
import SlashCommands

struct CommandPreview: View {
    //MARK: - Body
    
    var body: some View {
        HStack {
            if command.commandOwner == "integrated" {
                Image("InternalCommandImage")
                    .commandImage(imageSize: .list)
            }
            VStack (alignment: .leading) {
                Text("/ \(command.command)")
                    .boldSubheadline()
                if command.commandOwner == "integrated" {
                    Text(LocalizedStringKey(command.description))
                        .font(.caption)
                }
                else {
                    Text(command.description)
                        .font(.caption)
                }
            }
            Spacer()
        }
        .onTapGesture {
            currentCommand = command
            commandInput = "/\(command.command) "
        }
        .overlay(alignment: .topTrailing){
            CommandOwnerOverlayView(command: command)
        }
        
    }
    
    //MARK: - Params
    
    let command: any Command
    @Binding var currentCommand: (any Command)?
    @Binding var commandInput: String
    
    //MARK: -
}

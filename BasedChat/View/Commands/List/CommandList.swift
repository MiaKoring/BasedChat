import Foundation
import SwiftUI
import SlashCommands

struct CommandList: View {
    //MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack{
                ForEach(relevantCommands, id: \.id) { command in
                    CommandPreview(command: command, currentCommand: $currentCommand, commandInput: $commandInput)
                }
            }
            .padding(.bottom, 5)
        }
        .padding(.top, 5)
    }
    
    //MARK: - Params
    
    @Binding var relevantCommands: [any Command]
    @Binding var currentCommand: (any Command)?
    @Binding var commandInput: String
    
    //MARK: -
}

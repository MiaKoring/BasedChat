import SwiftUI
import SlashCommands
import UIKit

struct ContentVieww: View {
    @State var commandInput: String = ""
    @State var resultDisplay = ""
    @State var collection: CommandCollection = CommandCollection(commands: [])
    @State var currentCommand: (any Command)? = nil
    //will later be used to delete a param name
    @State var currentParams: [String: Range<String.Index>] = [:]
    @State var currentCommandLength: Int = 0
    @State var textViewHeight: CGFloat = 100
    @State var paramDuplicates: [String] = []
    @State var relevantCommands: [any Command] = []
    
    
    var body: some View {
        
        CommandList(relevantCommands: $relevantCommands, currentCommand: $currentCommand, commandInput: $commandInput)
        CommandDetailView(commandInput: $commandInput, collection: $collection, currentCommand: $currentCommand, relevantCommands: $relevantCommands)
        TextField("", text: $commandInput)
            .textFieldStyle(.roundedBorder)
        Button{
            
        } label: {
            Text("send")
        }
        Text(resultDisplay)
            .onAppear(){
                collection = CommandCollection(commands: [Bababa(completion: complete), Tableflip(completion: comp)])
            }
    }
    
    func comp(_ params: [String: Any])-> Void {
        resultDisplay = "\(params["message"] as! String) (╯°□°)╯︵ ┻━┻"
    }
    
    func complete(_ params: [String: Any])-> Void {
        if params.isEmpty {
            resultDisplay = "bababa"
            return
        }
        resultDisplay = "\(params["message"] as! String) bababa"
    }
}

#Preview {
    ContentVieww()
}





import Foundation
import SwiftUI
import SlashCommands

struct CommandParamView: View {
    //MARK: - Body
    
    var body: some View {
        Text(param.name)
            .padding(5)
            .font(.subheadline)
            .background(){
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .commandParamBackground(param, current: currentParam, set: setParams)
            }
    }
    
    //MARK: - Params
    
    var param: CommandParameter
    var currentParam: CommandParameter?
    var setParams: [String]
    
    //MARK: -
}

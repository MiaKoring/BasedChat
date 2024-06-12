import SwiftUI
import SlashCommands

extension RoundedRectangle {
    func pullbarStyle()-> some View {
        self
            .fill(.gray)
            .opacity(0.7)
            .frame(width: 50, height: 5)
            .padding()
    }
    
    func commandParamBackground(_ param: CommandParameter, current: CommandParameter?, set: [String])-> some View {
        if param == current {
            return self.fill(.blue)
        }
        if set.contains(param.name) {
            return self.fill(Color("ParamSet"))
        }
        return self.fill(.clear)
    }
}

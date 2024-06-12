import Foundation
import SwiftUI
import SlashCommands

struct CommandDetailView: View {
    //MARK: - Body
    
    var body: some View {
        VStack {
            if currentCommand != nil {
                VStack{
                    ScrollView(.horizontal) {
                        HStack{
                            if currentCommand!.commandOwner == "integrated" {
                                Image("InternalCommandImage")
                                    .commandImage(imageSize: .detail)
                            }
                            else {
                                Image("InternalCommandImage") // TODO: Replace with logic for Images from different apps
                                    .commandImage(imageSize: .detail)
                            }
                            
                            Text("/ \(currentCommand!.command)")
                                .boldSubheadline()
                                .padding(5)
                                .background() {
                                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                                        .fill(prefixWrong ? .red : .clear)
                                }
                            Spacer()
                            ForEach(currentCommand!.parameters, id: \.self) { param in
                                CommandParamView(param: param, currentParam: currentParam, setParams: setParams)
                                    .onTapGesture {
                                        paramTapped(param)
                                    }
                            }
                        }
                    }
                    HStack{
                        if currentCommand!.commandOwner == "integrated" {
                            Text(LocalizedStringKey(currentParam?.description ?? currentCommand!.description))
                                .font(.footnote)
                        }
                        else {
                            Text(currentParam?.description ?? currentCommand!.description)
                                .font(.footnote)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.vertical, 10)
            }
        }
        .onChange(of: commandInput) {
            DispatchQueue.main.async {
                commandInputChanged()
            }
        }
        .alert(LocalizedStringKey("CommandCheckError"), isPresented: $regexAlertShown) {
            Button {
                print("Input:\n\(commandInput)\n\nRegex: \(currentRegex ?? "")\n")
            } label: {
                Text(LocalizedStringKey("Report"))
            }
        }
    }
    
    //MARK: - Parameters
    
    @State var currentParam: CommandParameter? = nil
    @State var setParams: [String] = ["message"]
    @State var currentRegex: String? = "( message:)"
    @State var commandValid: Bool = true
    @State var prefixWrong = false
    @State var regexAlertShown = false
    
    @Binding var commandInput: String
    @Binding var collection: CommandCollection
    @Binding var currentCommand: (any Command)?
    @Binding var relevantCommands: [any Command]
    
    //MARK: -
}

import SwiftUI

struct SpecificReactionView: View {
    //MARK: - Body
    
    var body: some View {
        VStack{
            Button{
                showView = "overview"
            } label: {
                Label("", systemImage: "arrowshape.backward")
            }
            VStack{
                ForEach(0..<relevantUsers.count){index in
                    Text(relevantUsers[index])
                    if index+1 != relevantUsers.count{
                        Divider()
                    }
                }
            }
        }
    }
    
    //MARK: - Parameters
    
    @State var relevantUsers: [String]
    @Binding var showView: String
    
    //MARK: -
}

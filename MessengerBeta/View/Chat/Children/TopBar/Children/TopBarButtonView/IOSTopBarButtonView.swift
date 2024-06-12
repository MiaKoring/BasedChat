import SwiftUI

struct IOSTopBarButtonView: View {
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .frame(width: 35, height: 35)
            }
            Spacer()
            CallButtonsView()
        }
    }
    
    //MARK: - Parameters
    
    @Environment(\.presentationMode) var presentationMode
}

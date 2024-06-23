import SwiftUI

struct IOSTopBarButtonView: View {
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24))
                    .frame(width: 35, height: 35)
            }
            .buttonStyle(.plain)
            Spacer()
            CallButtonsView()
        }
    }
    
    //MARK: - Parameters
    
    @Environment(\.presentationMode) var presentationMode
}

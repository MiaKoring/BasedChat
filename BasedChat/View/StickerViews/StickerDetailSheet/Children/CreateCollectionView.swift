import SwiftUI
import RealmSwift

struct CreateCollection: View {
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
#if os(macOS)
            .buttonStyle(PlainButtonStyle())
#endif
            Spacer()
            Button {
                if disableCreationChoice {
                    createEmpty()
                    return
                }
                showCreationChoice = true
            } label: {
                Text("Create")
            }
#if os(macOS)
            .buttonStyle(PlainButtonStyle())
#endif
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        Form {
            CollectionCreationFormComponents(nameInput: $nameInput, priority: $priority)
        }
        .alert(Text("Name can't be empty"), isPresented: $showAlert) {
            AlertCloseButton(displayed: $showAlert)
        } message: {
            Text("Please enter a name")
        }
        .alert(Text("Failed to create collection"), isPresented: $showCreationError) {
            AlertCloseButton(displayed: $showCreationError)
        } message: {
            Text("Please try again")
        }
        .alert(Text("Do you want to add the selected sticker?"), isPresented: $showCreationChoice) {
            Button {
                create()
            } label: {
                Text("Yes")
            }
            Button {
                createEmpty()
            } label: {
                Text("No")
            }
        }
    }
    @State var nameInput: String = ""
    @State var priority: Int = 1
    @State var showAlert: Bool = false
    @State var showCreationError: Bool = false
    @State var showCreationChoice: Bool = false
    @ObservedResults(Sticker.self) var stickers
    var stickerHash: String = ""
    var stickerType: String = ""
    var stickerName: String = ""
    @Environment(\.dismiss) var dismiss
    var disableCreationChoice = false
}

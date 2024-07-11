import SwiftUI
import RealmSwift

struct CreateCollection: View {
    var body: some View {
        HStack {
            Button {
                showSheet = false
            } label: {
                Text("Cancel")
            }
#if os(macOS)
            .buttonStyle(PlainButtonStyle())
#endif
            Spacer()
            Button {
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
            Section(header: Text("Name")) {
                TextField("Name", text: $nameInput)
            }
            Section(header: Text("Sorting")) {
                Picker("Priority", selection: $priority) {
                    Text("High").tag(CollectionPriority.high)
                    Text("Normal").tag(CollectionPriority.regular)
                    Text("Low").tag(CollectionPriority.low)
                }
            }
        }
        .alert(Text("Name can't be empty"), isPresented: $showAlert) {
            Button {
                showAlert = false
            } label: {
                Text("OK")
            }
        } message: {
            Text("Please enter a name")
        }
        .alert(Text("Failed to create collection"), isPresented: $showCreationError) {
            Button {
                showCreationError = false
            } label: {
                Text("OK")
            }
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
    @State var priority: CollectionPriority = .regular
    @State var showAlert: Bool = false
    @State var showCreationError: Bool = false
    @State var showCreationChoice: Bool = false
    @ObservedResults(Sticker.self) var stickers
    var stickerHash: String
    var stickerType: String
    var stickerName: String
    @Binding var showSheet: Bool
}

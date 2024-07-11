import SwiftUI

struct CollectionCreationFormComponents: View {
    
    //MARK: - Body
    
    var body: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $nameInput)
        }
        Section(header: Text("Sorting")) {
            Picker("Priority", selection: $priority) {
                Text("High").tag(CollectionPriority.high.rawValue)
                Text("Normal").tag(CollectionPriority.regular.rawValue)
                Text("Low").tag(CollectionPriority.low.rawValue)
            }
        }
    }
    
    //MARK: - Parameters
    
    @Binding var nameInput: String
    @Binding var priority: Int
}

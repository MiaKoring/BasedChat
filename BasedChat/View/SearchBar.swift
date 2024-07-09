import SwiftUI

struct SearchBar: View {
    
    //MARK: - Body
    
    var body: some View {
        TextField("Search", text: $searchText)
            .lineLimit(1)
            .autocorrectionDisabled()
#if os(iOS)
            .textInputAutocapitalization(.never)
#endif
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, style: .init(lineWidth: 1))
            }
    }
    
    //MARK: - Parameters
    
    let label: LocalizedStringKey
    @Binding var searchText: String
    
    //MARK: - Initializer
    
    init(label: LocalizedStringKey, searchText: Binding<String>) {
        self.label = label
        self._searchText = searchText
    }
}

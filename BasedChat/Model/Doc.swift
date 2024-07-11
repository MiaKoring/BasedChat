import SwiftUI
import UniformTypeIdentifiers

struct Doc: FileDocument {
    var url: String
    static var readableContentTypes: [UTType]{[.gif]}
    
    init(url: String) {
        self.url = url
    }
    
    init(configuration: ReadConfiguration) throws {
        url = ""
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let file = try! FileWrapper(url: URL(fileURLWithPath: url), options: .immediate)
        
        return file
    }
}

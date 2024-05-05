import Foundation

class FileHandler {
    public static func loadFileIntern(fileName: String) -> Data? {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            return nil
        }
    }
}

import Foundation

class FileHandler {
    public static func loadFileIntern(fileName: String) -> Data? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else {
            return loadFromBundle(fileName: fileName)
        }
        
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        guard let res = loadData(url: fileURL) else {
            return loadFromBundle(fileName: fileName)
        }
        return res
    }
    
    public static func getPath(for fileName: String) -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else {
            return Bundle.main.url(forResource: fileName, withExtension: "")
        }
        
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return Bundle.main.url(forResource: fileName, withExtension: "")
        }
        return fileURL
    }
    
    
    fileprivate static func loadData(url: URL)-> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
    
    fileprivate static func loadFromBundle(fileName: String)-> Data? {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "") else {
            return nil
        }
        
        return loadData(url: fileURL)
    }
}

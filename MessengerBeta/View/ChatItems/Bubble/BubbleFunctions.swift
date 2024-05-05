import SwiftUI

extension Bubble {
    func extractURLs(from string: String)-> [URLRepresentable] {
        var urls: [URLRepresentable] = []
        
        do {
            let pattern = "https?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?"
            
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
            
            for match in matches {
                if let range = Range(match.range, in: string) {
                    let url = URLRepresentable(urlstr: String(string[range]))
                    urls.append(url)
                }
            }
        } catch {
            print("Fehler beim Extrahieren der URLs: \(error)")
        }
        
        return urls
    }
    
    func setAnimatedTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            withAnimation(.easeOut(duration: 0.1)) {
                showTimeFalse()
                timer.invalidate()
            }
        }
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            showTimeFalse()
            timer.invalidate()
        }
    }
    
    func showTimeTrue() {
        showTime = true
    }
    
    func showTimeFalse() {
        showTime = false
    }
}

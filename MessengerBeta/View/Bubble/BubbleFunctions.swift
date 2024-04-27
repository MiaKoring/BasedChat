import SwiftUI

extension Bubble{
    func extractURLs(from string: String) -> [URLRepresentable] {
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
    
    func toggleTime(animated: Bool = true){
        if !keyboardShown{
            if animated {
                animatedTimeToggle()
                return
            }
            timeToggle()
            return
        }
        else{
            #if canImport(UIKit)
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            #endif
        }
    }
    
    private func animatedTimeToggle(){
        if showTime{
            withAnimation(.easeOut(duration: 0.1)){
                showTime = false
            }
            return
        }
        
        withAnimation(.easeIn(duration: 0.1)){
            showTime = true
        }
        
        if timer != nil && timer!.isValid{
            timer!.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false){timer in
            withAnimation(.easeOut(duration: 0.1)){
                showTime = false
                timer.invalidate()
            }
        }
    }
    
    private func timeToggle(){
        if showTime{
            showTime = false
            return
        }
        
        showTime = true
        
        if timer != nil && timer!.isValid{
            timer!.invalidate()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false){timer in
            showTime = false
            timer.invalidate()
        }
    }
}

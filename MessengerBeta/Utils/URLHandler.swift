import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

class URLHandler{
    public static func openURL(_ urlString: String)-> Bool{
        guard let url = URL(string: urlString) else {
            return false
        }
        #if canImport(UIKit)
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
        #elseif canImport(AppKit)
        NSWorkspace.shared.open(url)
        #endif
        return true
    }
}

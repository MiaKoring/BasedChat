import SwiftUI

#if canImport(UIKit)
public extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
#endif

import SwiftUI

public struct SafeAreaInsetsKey: EnvironmentKey {
    public static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

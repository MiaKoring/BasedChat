import Foundation

extension Date{
    var intTimeIntervalSince1970: Int {
        Int(self.timeIntervalSince1970)
    }
}

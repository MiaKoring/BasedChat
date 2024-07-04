import Foundation

struct SendableSticker : Equatable {
    var uuid = UUID()
    var name: String
    var hash: String
    var type: String
}

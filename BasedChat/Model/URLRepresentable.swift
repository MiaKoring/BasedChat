import Foundation

struct URLRepresentable: Identifiable, Hashable {
    public let id: UUID = UUID()
    public let urlstr: String
}

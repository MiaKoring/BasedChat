extension Sticker {
    var isIntegrated: Bool {
        self.collections.contains(where: {$0.name == "integrated"})
    }
}

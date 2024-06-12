import Foundation

extension StickerImageView {
    func loadImage() {
        DispatchQueue.global().async {
            if let res = FileHandler.loadFileIntern(fileName: "\(name).\(fileExtension)") {
                DispatchQueue.main.async {
                    data = res
                }
            }
            isDone = false
        }
    }
}

import Foundation

extension StickerImageView {
    func loadImage() {
        DispatchQueue.global().async {
            if let res = FileHandler.loadFileIntern(fileName: "\(name).\(fileExtension)"), data.isNil {
                DispatchQueue.main.async {
                    data = res
                    searched = true
                }
            }
            else {
                DispatchQueue.main.async {
                    searched = true
                }
            }
        }
    }
}

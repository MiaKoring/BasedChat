/*import SwiftUI

struct Test: View {
    var body: some View {
        VStack {
            if let originalImage = UIImage(named: "InternalCommandImage"), let resizedImage = resizeImage(image: originalImage, targetSize: CGSize(width: 20, height: 20)) {
                Text("Custom Emoji: ").font(.system(size: 20)) + Text(Image(uiImage: resizedImage))+Text(" another random text")
            } else {
                Text("Emoji not found")
            }
        }
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Calculate the scaling factor that preserves aspect ratio
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Calculate the new size that fits in the target size
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        // Create a new image context with the target size
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        
        // Calculate the drawing origin to center the image in the context
        let drawingOrigin = CGPoint(x: (targetSize.width - scaledImageSize.width) / 2,
                                    y: (targetSize.height - scaledImageSize.height) / 2)
        
        // Draw the scaled image in the context
        image.draw(in: CGRect(origin: drawingOrigin, size: scaledImageSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

#Preview {
    Test()
}
*/

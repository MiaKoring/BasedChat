import PhotosUI
import SwiftUI

struct StickerPicker: View {
    
    //TODO: Add GIF support
    var body: some View {
        VStack {
            PhotosPicker("Select Image", selection: $item, matching: .images)
                .buttonStyle(PlainButtonStyle())
        }
        .onChange(of: item) {
            //TODO: Add MacOS Pendant
#if os(iOS)
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self) {
                    // Entferne Metadaten
                    let strippedData = removeMetadata(from: data)
                    
                    // Skaliere das Bild
                    let maxSize = CGSize(width: 300, height: 300)
                    if let strippedImage = UIImage(data: strippedData),
                       let jpegData = strippedImage.scaleProportionally(to: maxSize).jpegData(compressionQuality: 0.8), let uiImage = UIImage(data: jpegData) {
                        image = Image(uiImage: uiImage)
                        imageData = jpegData
                    } else {
                        print("Failed to process image")
                    }
                } else {
                    print("Failed to load image")
                }
            }
#endif
        }
    }
    
    //MARK: - Parameters
    
    @State private var item: PhotosPickerItem?
    @Binding var image: Image?
    @Binding var imageData: Data?
    
    //MARK: - Functions
    
    func removeMetadata(from imageData: Data) -> Data {
        let source = CGImageSourceCreateWithData(imageData as CFData, nil)!
        let UTI = CGImageSourceGetType(source)!
        
        let data = NSMutableData()
        let destination = CGImageDestinationCreateWithData(data as CFMutableData, UTI, 1, nil)!
        
        let options: [NSString: Any] = [
            kCGImageDestinationMetadata: NSNull()  // Entfernt alle Metadaten
        ]
        
        CGImageDestinationAddImageFromSource(destination, source, 0, options as CFDictionary)
        CGImageDestinationFinalize(destination)
        
        return data as Data
    }
    
}

import Foundation
import SwiftUI
import SwiftChameleon
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct StickerImageView: View {
    
    //MARK: - Body
    var body: some View {
        VStack{
            if !isDone && fileExtension == "gif" {
                if !data.isNil {
                    #if canImport(UIKit)
                    GIFImage(data: data!, repetitions: (2 * durationFactor).int) {
                        isDone = true
                    }
                    #elseif canImport(AppKit)
                    GIFImage(data: data!, animationDuration: durationFactor)
                    #endif
                }
            }
            else {
                if !data.isNil {
#if canImport(UIKit)
                    if let image = UIImage(data: data!) {
                        Image(uiImage: image)
                            .scaleToFit()
                            .frame(width: width, height: height)
                    }
#elseif canImport(AppKit)
                    if let image = NSImage(data: data!) {
                        Image(nsImage: image)
                            .scaleToFit()
                    }
#endif
                }
                else {
                    if isDone {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .font(.title)
                    }
                    else {
                        VStack {
                            Image(systemName: "x.circle")
                                .foregroundStyle(Color.red)
                                .font(.title)
                            Text(LocalizedStringKey("ressourceNotFound"))
                        }
                        .padding(20)
                    }
                }
            }
        }
        .frame(width: width, height: height)
        .thinClearBackground(clear: !data.isNil)
        .onAppear(){
            loadImage()
        }
    }
    
    //MARK: - Parameters
    @State var isDone = false
    @State var name: String
    @State var fileExtension: String
    @State var data: Data? = nil
    var width: Double = 200
    var height: Double = 200
    var durationFactor = 10.0
}

#Preview {
    @Previewable @State var data: Data? = nil
    StickerImageView(name: "TalkingCat", fileExtension: "gif")
        .frame(width: 200, height: 200)
}

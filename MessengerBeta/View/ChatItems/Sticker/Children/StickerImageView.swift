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
                    GIFImage(data: data!, repetitions: 20) {
                        isDone = true
                    }
                    #elseif canImport(AppKit)
                    GIFImage(data: data!, animationDuration: 10.0)
                    #endif
                }
            }
            else {
                if !data.isNil {
#if canImport(UIKit)
                    if let image = UIImage(data: data!) {
                        Image(uiImage: image)
                            .scaleToFit()
                            .frame(width: 200, height: 200)
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
                    }
                }
            }
        }
        .frame(width: 200, height: 200)
        .thinClearBackground(clear: !data.isNil)
        .onAppear(){
            loadImage()
        }
    }
    
    //MARK: - Parameters
    @State var isDone = true
    @State var name: String
    @State var fileExtension: String
    @State var data: Data? = nil
}

#Preview {
    StickerImageView(name: "TalkingCat", fileExtension: "gif")
        .frame(width: 200, height: 200)
}

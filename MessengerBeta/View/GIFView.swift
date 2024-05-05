import Foundation
import SwiftUI
import WebKit
#if canImport(UIKit)
import UIKit

struct GIFView: UIViewRepresentable {
    private let data: Data
    private let url: URL
    
    init(_ data: Data, url: URL) {
        self.data = data
        self.url = url
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = self.url
        let data = self.data
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
    
}

#elseif canImport(AppKit)
//TODO: fix image getting too big
import AppKit

struct GIFView: NSViewRepresentable {
    private let data: Data
    private let url: URL
    
    init(_ data: Data, url: URL) {
        self.data = data
        self.url = url
    }
    
    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.image = NSImage(data: self.data)
        imageView.animates = true
        loadImage(imageView: imageView)
        return imageView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        loadImage(imageView: nsView)
    }
    
    private func loadImage(imageView: NSImageView) {}
}

#endif

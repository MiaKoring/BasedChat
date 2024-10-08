import Foundation
import SwiftUI
import SwiftChameleon

struct LinkView: View {
    //MARK: - Body
    
    var body: some View {
        HStack {
            if !URLs.isEmpty {
                if URLs.count == 1 {
                    LinkStringDisplay(messageText: messageText, url: URLs.first?.urlstr)
                        .onTapGesture {
                            showURLInvalidAlert = !URLHandler.open(urlString: URLs.first!.urlstr)
                        }
                        .contextMenu {
                            Text(URLs.first!.urlstr)
                        }
                }
                else {
                    LinkStringDisplay(messageText: messageText, url: URLs.first?.urlstr)
                        .overlay(alignment: .trailing) {
                            Text("+\(URLs.count - 1)")
                                .padding(3)
                                .background {
                                    RoundedRectangle(cornerRadius: 50)
                                        .fill(.gray)
                                }
                                .padding(3)
                        }
                        .contextMenu {
                            ForEach(URLs, id: \.self) { representable in
                                if let url = URL(string: representable.urlstr) {
                                    Button {
                                        URLHandler.open(url)
                                    } label: {
                                        Text(representable.urlstr)
                                    }
                                }
                            }
                        }
                }
            }
        }
            .alert("Invalid URL", isPresented: $showURLInvalidAlert) {
                AlertCloseButton(displayed: $showURLInvalidAlert)
            }
    }
    
    //MARK: - Parameters
    
    let URLs: [URLRepresentable]
    let messageText: String
    @State var showURLInvalidAlert = false
    
    //MARK: -
}

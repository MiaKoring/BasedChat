import Foundation
import SwiftUI
import SwiftChameleon
import SwiftData

struct ChatTopBar: View {
    
    //MARK: - Body
    var body: some View {
        VStack {
            ZStack{
                #if canImport(UIKit)
                if UIDevice.isIPhone {
                    IOSTopBarButtonView()
                }
                else {
                    TopBarButtonView(showNavigation: $showNavigation)
                }
                #else
                TopBarButtonView(showNavigation: $showNavigation)
                #endif
                HStack {
                    Text(title)
                        .lineLimit(1)
                        .bold()
                        .overlay(alignment: .leading) {
                        if !data.isNil {
#if canImport(UIKit)
                                if let image = UIImage(data: data!) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 35, height: 35)
                                        .offset(x: -50)
                                }
                                
#elseif canImport(AppKit)
                                if let image = NSImage(data: data!) {
                                    Image(nsImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 35, height: 35)
                                        .offset(x: -50)
                                }
#endif
                            }
                            else {
                                Circle()
                                    .fill(.blue.mix(with: .cyan, by: 0.3))
                                    .frame(width: 35, height: 35)
                                    .offset(x: -50)
                            }
                        }
                }
                .padding(.horizontal, 100)
            }
            .frame(maxWidth: 550)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .onAppear(){
            if ChatType(rawValue: chat.type) == .direct {
                guard
                    let reciepient = chat.participants.first(where: {!$0.isCurrentUser}),
                    let reciepientContact = try? context.fetch(FetchDescriptor(predicate: #Predicate<Contact>{
                    $0.userID == reciepient
                })).first else {
                    print("Contact not found")
                    return
                }
                contact = reciepientContact
                title = contact?.savedAs ?? contact?.username ?? "Not Found"
                
            }
            //TODO: add Group
            loadImage()
        }
    }
    func loadImage() {
        DispatchQueue.global().async {
            if let res = FileHandler.loadFileIntern(fileName: "\(contact?.imagehash ?? "").jpg") {
                DispatchQueue.main.async {
                    data = res
                }
            }
            else {
                print("failed to load image")
            }
        }
    }
    //MARK: - Parameters
    @Binding var showNavigation: NavigationSplitViewVisibility
    @Binding var chat: Chat
    @State var data: Data? = nil
    @State var title: String = ""
    @State var contact: Contact? = nil
    @State var contactNotFound: Bool = false
    @Environment(\.modelContext) var context
}

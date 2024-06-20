import Foundation
import SwiftUI
import SwiftChameleon
import SwiftData
import MediaPlayer

struct ChatTopBar: View {
    
    //MARK: - Body
    var body: some View {
        VStack {
            ZStack {
                //if eventCount > 0 {
                if showEvents {
                        VStack {
                            MediaControlView()
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 10)
                    }
                //}
                VStack{
                    ZStack {
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
                                                .contactPicture()
                                        }
                                        
#elseif canImport(AppKit)
                                        if let image = NSImage(data: data!) {
                                            Image(nsImage: image)
                                                .contactPicture()
                                        }
#endif
                                    }
                                    else {
                                        Circle()
                                            .fill(.blue.mix(with: .cyan, by: 0.3))
                                            .contactPicture()
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: 550)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .shadow(radius: 5.0)
                    }
                    if eventIsActive() && showEvents { Spacer() }
                }
            }
            .background(){
                if eventIsActive() && showEvents{
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.ultraThinMaterial)
                }
            }
            .frame(maxHeight: 80)
            .padding(.horizontal, 15)
            .padding(.top, showEvents ? 15 : 0)
            .onLongPressGesture {
                withAnimation {
                    showEvents.toggle()
                }
            }
            Spacer()
        }
        .onAppear(){
            appeared()
        }
        .onDisappear {
            disappeared()
        }
    }
    
    //MARK: - Parameters
    @Binding var showNavigation: NavigationSplitViewVisibility
    @Binding var chat: Chat
    
    @State var data: Data? = nil
    @State var title: String = ""
    @State var contact: Contact? = nil
    @State var contactNotFound: Bool = false
    @State var eventCount: Int = 0
    @State var showEvents: Bool = false
    @Environment(\.modelContext) var context
}

#Preview {
    @Previewable @State var showNavigation: NavigationSplitViewVisibility = .detailOnly
    @Previewable @State var chat: Chat = Chat(title: "Chat")

    ChatTopBar(showNavigation: $showNavigation, chat: $chat)
}

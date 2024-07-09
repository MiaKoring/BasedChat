import Foundation
import SwiftUI
import SwiftChameleon
import RealmSwift
#if os(iOS)
import MediaPlayer
#endif

struct ChatTopBar: View {
    #if os(iOS)
    @StateObject private var musicPlayerManager = MusicPlayerManager()
    #endif
    //MARK: - Body
    var body: some View {
        VStack {
            ZStack {
                //if eventCount > 0 {
                if showEvents {
#if os(iOS)
                        VStack {
                            MediaControlView()
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 10)
#endif
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
                #if os(iOS)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { endedGesture in
                            var verticalDistance = endedGesture.location.y - endedGesture.startLocation.y
                            verticalDistance = verticalDistance < 0 ? 0 - verticalDistance : verticalDistance
                            var horizontalDistance = endedGesture.location.x - endedGesture.startLocation.x
                            horizontalDistance = horizontalDistance < 0 ? 0 - horizontalDistance : horizontalDistance
                            
                            if horizontalDistance > verticalDistance {
                                if (endedGesture.location.x - endedGesture.startLocation.x) > 0 {
                                    musicPlayerManager.skipToNextItem()
                                    return
                                }
                                musicPlayerManager.skipToPreviousItem()
                                return
                            }
                            else {
                                if (endedGesture.location.y - endedGesture.startLocation.y) > 0 {
                                    showEvents = true
                                    return
                                }
                                showEvents = false
                            }
                        }
                )
                #endif
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
    @ObservedRealmObject var chat: Chat
    
    @State var data: Data? = nil
    @State var title: String = ""
    @State var contact: Contact? = nil
    @State var contactNotFound: Bool = false
    @State var eventCount: Int = 0
    @State var showEvents: Bool = false
}

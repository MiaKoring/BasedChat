import Foundation
import SwiftUI
import SwiftChameleon
import SwiftData

struct StickerView: View, TimeToggler, ReactionInfluenced {
    var body: some View {
        VStack{
            HStack {
                if message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
                VStack{
                    if !message.stickerHash.isEmpty {
                        ReplyView(message: message, scrollTo: $scrollTo, triggerScroll: $triggerScroll, glowOriginMessage: $glowOriginMessage)
                        StickerImageView(name: message.stickerHash, fileExtension: message.stickerType, data: $data)
                    }
                }
                .overlay(alignment: message.sender.isCurrentUser ? .bottomLeading : .bottomTrailing){
                    ReactionDisplayView(reactionContainer: reactionContainer, textCount: 10, reactionData: reactionData, sender: message.sender, opaque: true, bottomCardReaction: $bottomCardReaction, showStickerDetail: $showStickerDetail)
                        .padding(message.sender.isCurrentUser ? .leading : .trailing, 20)
                        .offset(.init(width: 0.0, height: 17.0))
                }
                .padding(message.type.range(of: "reply", options: .caseInsensitive).isNil ? 10 : 6)
                .bubbleBackground(isCurrent: message.sender.isCurrentUser, background: message.background, show: !message.type.range(of: "reply", options: .caseInsensitive).isNil)
                .onTapGesture {
                    tapped()
                }
                .contextMenu() {
                    BubbleContextMenu(message: message, replyTo: $replyTo, deleteAlertPresented: $deleteAlertPresented)
                }
                if !message.sender.isCurrentUser { Spacer(minLength: minSpacerWidth) }
            }
            if showTime{ BubbleTimeDisplayView(message: message) }
        }
        .sheet(isPresented: $stickerSheetPresented, content: {
            //TODO: Create Subview
            VStack{
                #if canImport(UIKit)
                RoundedRectangle(cornerRadius: 25)
                    .pullbarStyle()
                #else
                HStack{
                    CloseOnlyButtons(presented: $stickerSheetPresented)
                    Spacer()
                }
                #endif
                Spacer()
                StickerImageView(name: message.stickerHash, fileExtension: message.stickerType, data: $data, width: 200, height: 200, durationFactor: 30)
                List {
                    Button {
                        if let favs = favourites.first, favs.stickers.contains(where: {$0.hashString == message.stickerHash}) {
                            favs.stickers.removeAll(where: {$0.hashString == hash})
                            return
                        }
                        addToFavourites()
                    } label: {
                        if let favs = favourites.first {
                            Label("Add to Favourites", systemImage: favs.stickers.contains(where: {$0.hashString == message.stickerHash}) ? "star.fill" : "star")
                        }
                        else {
                            Label("Add to Favourites", systemImage: "star")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .presentationDetents([.medium])
            .presentationBackground(.ultraThickMaterial)
        })
        .onAppear(){
            appeared()
        }
        .alert(LocalizedStringKey("DeleteAlert"), isPresented: $deleteAlertPresented) {
            Button(role: .destructive) {
                messageToDelete = message
            } label: {
                Text(LocalizedStringKey("Delete"))
            }
        }
        .alert("Couldn't find sticker", isPresented: $showAddStickerError) {
            Button(role: .cancel) {
            } label: {
                Text("OK")
            }
        }
    }
    
    @State var hash = ""
    @Binding var message: Message
    @Binding var triggerScroll: Bool
    @Binding var glowOriginMessage: UUID?
    @Binding var scrollTo: UUID?
    @Binding var showTime: Bool
    @Binding var keyboardShown: Bool
    @Binding var timer: Timer?
    @Binding var replyTo: Reply?
    @State var reactionContainer = ""
    @State var doubletapTimer: Timer? = nil
    @State var stickerSheetPresented = false
    @State var reactionData: Reaction = Reaction(mostUsed: "", countString: "", emojisCount: [:], differentEmojisCount: 0, peopleReactions: [:])
    @Binding var showStickerDetail: Bool
    @Binding var bottomCardReaction: Reaction?
    @Binding var messageToDelete: Message?
    let minSpacerWidth: Double
    @State var deleteAlertPresented = false
    @Environment(\.modelContext) var context
    @State var data: Data? = nil
    @State var showAddStickerError: Bool = false
    @Query( {
        var descriptor = FetchDescriptor(predicate: #Predicate<StickerCollection>{$0.name == "favourites"})
        descriptor.fetchLimit = 1
        return descriptor
    }() ) var favourites: [StickerCollection]
    #if !canImport(UIKit)
    @State var sheetCloseHovered = false
    #endif
    
    
    var formattedChars: [FormattedChar] =  [] //conformance
}


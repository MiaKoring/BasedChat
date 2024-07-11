import SwiftUI
import Security
import RealmSwift

let testMessageUUID: UUID = UUID()
let testChatUUID: UUID = UUID()
let testMessagesUUID: UUID = UUID()

let defaultMessages = [
    TestMessage(text: "Gute Nacht", sender: 1, time: 1704126197),
    TestMessage(text: "Hey, hast du grad Zeit? Wir wollten mal noch unser Wochende planen 😅", sender: 1, time: 1704191292),
    TestMessage(text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", sender: 2, time: 1704191343),
    TestMessage(text: "So habe ich geschaut. Es klappt. Hast du die anderen schon gefragt?", sender: 2, time: 1704191415),
    TestMessage(text: "Ja, die haben alle Zeit", sender: 1, time: 1704191432),
    TestMessage(text: "womit wollen wir anfangen?", sender: 1, time: 1704191443),
    TestMessage(text: "Ich würde vorschlagen das wir erstmal in ein schönes Restaurant gehen. Ich hätte das La Casa im Blick.", sender: 2, time: 1704191482),
    TestMessage(text: "gibt es da auch was veganes auf der Speisekarte?", sender: 1, time: 1704191531),
    TestMessage(text: "Das", sender: 2, time: 1704191592),
    TestMessage(text: "Oder war es doch Tom ?", sender: 2, time: 1704191603),
    TestMessage(text: "Ich bringe das grade etwas durcheinander. Vielleicht kannst du nochmal nachfragen. Du hast die Nummern von denen.", sender: 2, time: 1704191655),
    TestMessage(text: "Anna war es. Sie verträgt kein Gluten", sender: 1, time: 1704191703),
    TestMessage(text: "Gut dass du dran denkst", sender: 1, time: 1704191717),
    TestMessage(text: "hatte ich grade garnicht auf dem schirm", sender: 1, time: 1704191727),
    TestMessage(text: "Perfekt, dann rufe ich dort später mal an. Soll ich noch jemanden abholen ? Und, wenn ja könntest du mir die Adressen weiterleiten ? Würde sich anbieten da sie auf dem Weg liegen und dann müssen wir nicht mit so vielen Autos fahren.", sender: 2, time: 1704191733),
    TestMessage(text: "Ja, mich und Luca wäre super. Meine Addresse kennst du ja, Luca wohnt im Randomweg 787", sender: 1, time: 1704191892),
    TestMessage(text: "Alles klar. Habe ich dann jetzt direkt im Navi abgespeichert. Passt es dann Luca, wenn ich ihn als erstes abhole?", sender: 2, time: 1704191965),
    TestMessage(text: "Ja klar", sender: 1, time: 1704191975),
    TestMessage(text: "Wäre dann so um ca 18 Uhr vor seiner Haustür.", sender: 2, time: 1704192007),
    TestMessage(text: "super, gebe ich weiter", sender: 1, time: 1704192018),
    TestMessage(text: "Er freut sich", sender: 1, time: 1704192037),
    TestMessage(text: "Perfekt, ich mich auch. Sollte noch was sein melde dich einfach.", sender: 2, time: 1704192082),
    TestMessage(text: "Mach ich, bis dann", sender: 1, time: 1704192129),
    TestMessage(text: "Hallo~ ich _bin *Mia_ lol* ~Test _123_~", sender: 1, time: 1704566685)
]

let realm = try! Realm()


@main
struct BasedChatApp: SwiftUI.App {
#if canImport(UIKit)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    @State public static var currentUserID: Int = 1
    @State public static var currentToken: String? = nil
    
    var body: some Scene {
        WindowGroup {
            FirstView()
        }
#if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
#endif
    }
}

#if canImport(UIKit)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        switch extensionPointIdentifier {
            case UIApplication.ExtensionPointIdentifier.keyboard:
                return false
            default:
                return true
        }
    }
}
#endif

struct FirstView: View {
    @State var selectedChat: Chat? = nil
    @State var showNavigation:NavigationSplitViewVisibility = .all
    @ObservedResults(StickerCollection.self) var collections
    @ObservedResults(Contact.self) var contacts
    @ObservedResults(Chat.self) var chats
    var body: some View {
        HStack {
            if  collections.isEmpty {
                Text("creating default sticker...")
                    .onAppear(){
                        let integratedCollection = StickerCollection(name: "integrated", priority: .low)
                        let bababa = Sticker(name: "Bababa", type: "gif", hashString: "69f9a9524a902c8fc8635787ab5c65ce21e843d96f8bc52cdf7fd20b7fc5006b")
                        let favouritesCollection = StickerCollection(name: "favourites",  priority: .high)
                        try? realm.write {
                            integratedCollection.stickers.append(bababa)
                            $collections.append(integratedCollection)
                            $collections.append(favouritesCollection)
                        }
                    }
            }
            if contacts.isEmpty{
                Text("creating contacts")
                    .onAppear(){
                        let mia = Contact(userID: 1, username: "mia", savedAs: "Mia")
                        let eli = Contact(userID: 2, username: "eli", savedAs: "Eli", pfpHash: "6c71ce3d7f3067d8845d8a3b85e414c45aa250aea1c7bf699e2d58c5bc62e71f")
                        try? realm.write {
                            $contacts.append(mia)
                            $contacts.append(eli)
                        }
                    }
            }
            if contacts.count == 2 && chats.isEmpty {
                Text("creating chat...")
                    .onAppear() {
                        let chat = Chat(title: "Eli", currentMessageID: 0, imagehash: "", type: .direct)
                        var eli = realm.objects(Contact.self).where {
                            $0.userID == 2
                        }
                        var mia = realm.objects(Contact.self).where {
                            $0.userID == 1
                        }
                        chat.participants.append(mia.first!)
                        chat.participants.append(eli.first!)
                        for i in 0..<defaultMessages.count {
                            let formattedSubstrs = StringFormatterCollection.formatSubstrs(defaultMessages[i].text)
                            let message = Message(time: defaultMessages[i].time, type: .standalone, text: defaultMessages[i].text, messageID: i, stickerHash: "", stickerName: "", stickerType: "")
                            for substr in formattedSubstrs {
                                message.formattedSubstrings.append(substr)
                            }
                            
                            switch defaultMessages[i].sender {
                            case 1:
                                try? realm.write {
                                    mia.first!.messages.append(message)
                                }
                            case 2:
                                try? realm.write {
                                    eli.first!.messages.append(message)
                                }
                            default:
                                break
                            }
                            try? realm.write {
                                chat.messages.append(message)
                                chat.currentMessageID += 1
                            }
                        }
                        try? realm.write {
                            mia.first?.chats.append(chat)
                            eli.first?.chats.append(chat)
                            $chats.append(chat)
                        }
                    }
            }
            if !chats.isEmpty && !chats.first!.messages.isEmpty && !contacts.isEmpty {
                #if canImport(UIKit)
                if UIDevice.isIPhone {
                    NavigationStack {
                        List {
                            //NavigationLink("Chat", destination: ChatView(chat: chats.first!, showNavigation: $showNavigation))
                            NavigationLink("Chat") {
                                ChatView(chat: chats.first!, showNavigation: $showNavigation)
                                    .background {
                                        DefaultBackground()
                                            .ignoresSafeArea()
                                    }
                                
                            }
                        }
                    }
                }
                else {
                    NavigationSplitView(columnVisibility: $showNavigation) {
                        ForEach(chats, id: \.id ) { chat in //TODO: Sort Chats by latest message
                            Button {
                                selectedChat = chat
                            } label: {
                                Text(chat.title)
                            }
                            .toolbar(removing: .sidebarToggle)
                        }
                    } detail: {
                        if selectedChat != nil {
                            ChatView(chat: selectedChat!, showNavigation: $showNavigation)
                                .background {
                                    DefaultBackground()
                                        .ignoresSafeArea()
                                }
                        }
                        else {
                            Image(systemName: "exclamationmark.bubble")
                            Text("select chat")
                        }
                    }
                }
                #else
                NavigationSplitView(columnVisibility: $showNavigation) {
                    ForEach(chats, id: \.id ) { chat in //TODO: Sort Chats by latest message
                        Button {
                            selectedChat = chat
                        } label: {
                            Text(chat.title)
                        }
                        .toolbar(removing: .sidebarToggle)
                    }
                } detail: {
                    if selectedChat != nil {
                        ChatView(chat: selectedChat!, showNavigation: $showNavigation)
                    }
                    else {
                        Image(systemName: "exclamationmark.bubble")
                        Text("select chat")
                    }
                }
                #endif
                
            }
        }
    }
}



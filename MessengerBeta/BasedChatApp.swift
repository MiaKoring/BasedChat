//
//  MessengerBetaApp.swift
//  MessengerBeta
//
//  Created by Mia Koring on 30.12.23.
//

import SwiftUI
import SwiftData
import Security

let testMessageUUID: UUID = UUID()
let testChatUUID: UUID = UUID()
let testMessagesUUID: UUID = UUID()
let defaultChat = Chat(title: "lelele", participants: [1, 2])
let defaultMessages: [Message] = [Message(time: 1704126197, sender: 1, text: "Gute Nacht", reactions: [1: "🙃", 2: "😆"], messageID: 1), Message(time: 1704191292, sender: 1, text: "Hey, hast du grad Zeit? Wir wollten mal noch unser Wochende planen 😅", messageID: 2), Message(time: 1704191343, sender: 2, text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", id: testMessageUUID, messageID: 3), Message(time: 1704191415, sender: 2, text: "So habe ich geschaut. Es klappt. Hast du die anderen schon gefragt?", messageID: 4), Message(time: 1704191432, sender: 1, text: "Ja, die haben alle Zeit", messageID: 5), Message(time: 1704191443, sender: 1, text: "womit wollen wir anfangen?", messageID: 6), Message(time: 1704191482, sender: 2, text: "Ich würde vorschlagen das wir erstmal in ein schönes Restaurant gehen. Ich hätte das La Casa im Blick.", messageID: 7), Message(time: 1704191531, sender: 1, text: "gibt es da auch was veganes auf der Speisekarte?", messageID: 8), Message(time: 1704191592, sender: 2, text: "Das", reactions: [1: "🙃", 2: "😆"], messageID: 9), Message(time: 1704191603, sender: 2, text: "Oder war es doch Tom ?", messageID: 10), Message(time: 1704191655, sender: 2, text: "Ich bringe das grade etwas durcheinander. Vielleicht kannst du nochmal nachfragen. Du hast die Nummern von denen.", messageID: 11), Message(time: 1704191703, sender: 1, text: "Anna war es. Sie verträgt kein Gluten", messageID: 12), Message(time: 1704191717, sender: 1, text: "Gut dass du dran denkst", messageID: 13), Message(time: 1704191727, sender: 1, text: "hatte ich grade garnicht auf dem schirm", messageID: 14), Message(time: 1704191733, sender: 2, text: "Perfekt, dann rufe ich dort später mal an. Soll ich noch jemanden abholen ? Und, wenn ja könntest du mir die Adressen weiterleiten ? Würde sich anbieten da sie auf dem Weg liegen und dann müssen wir nicht mit so vielen Autos fahren.", messageID: 15), Message(time: 1704191892, sender: 1, text: "Ja, mich und Luca wäre super. Meine Addresse kennst du ja, Luca wohnt im Randomweg 787", messageID: 16), Message(time: 1704191965, sender: 2, text: "Alles klar. Habe ich dann jetzt direkt im Navi abgespeichert. Passt es dann Luca, wenn ich ihn als erstes abhole?", messageID: 17), Message(time: 1704191975, sender: 1, text: "Ja klar", messageID: 18), Message(time: 1704192007, sender: 2, text: "Wäre dann so um ca 18 Uhr vor seiner Haustür.", messageID: 19), Message(time: 1704192018, sender: 1, text: "super, gebe ich weiter", messageID: 20), Message(time: 1704192037, sender: 1, text: "Er freut sich", messageID: 21), Message(time: 1704192082, sender: 2, text: "Perfekt, ich mich auch. Sollte noch was sein melde dich einfach.", messageID: 22), Message(time: 1704192129, sender: 1, text: "Mach ich, bis dann", messageID: 23), Message(time: 1704566685, sender: 1, text: "Hallo~ ich _bin *Mia_ lol* ~Test _123_~", messageID: 24)]




@main
struct BasedChatApp: App {
    @State public static var currentUserID: Int? = 1
    @State public static var currentToken: String? = nil
    
    
    var body: some Scene {
        WindowGroup{
            FirstView()
                .modelContainer(for: [Chat.self, Contact.self])
        }
    }
}

struct FirstView: View{
    @Query var chats: [Chat]
    @Query var contacts: [Contact]
    @Environment(\.modelContext) var context
    var body: some View{
        HStack{
            if chats.isEmpty{
                Text("creating chat...")
                    .onAppear(){
                        context.insert(Chat(title: "Test", participants: [1, 2]))
                    }
            }
            else if chats.first!.messages.isEmpty{
                Text("creating messages...")
                    .onAppear(){
                        for message in defaultMessages{
                            chats.first!.messages.append(message)
                        }
                    }
            }
            else if contacts.isEmpty{
                if contacts.isEmpty{
                    Text("creating contacts")
                        .onAppear(){
                            context.insert(Contact(userID: 1, username: "mia", publicKey: "abc", savedAs: "Mia", isLocalUser: true))
                            context.insert(Contact(userID: 2, username: "eli", publicKey: "def", savedAs: "Eli"))
                        }
                }
            }
            else{
                //BubblePreviewProvider()
                ChatView(chat: chats.first!)
            }
        }
    }
}

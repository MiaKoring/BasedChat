import SwiftUI

extension Dictionary where Value: Equatable{
    func keys(forValue value: Value)-> [Key]{
        return compactMap{ (key, element) in
            return element == value ? key : nil
            
        }
    }
}

struct Chat: Identifiable, Equatable, Hashable{
    let id: UUID = UUID()
    var title: String
    var participants: [String]
    var messages: [Message] = []
}

struct Message: Identifiable, Equatable, Hashable{
    var time: String
    var sender: String
    var type: String = "normal"
    var reply: Reply = Reply(originID: testMessageUUID, text: "", sender: "")
    let attachments: [Attachment] = []
    var text: String
    var reactions: [String: String] = [:]
    var background: String = "normal"
    var id: UUID = UUID()
}

struct Attachment: Equatable, Hashable{
    let type: String
    let dataPath: String
}

struct Reaction{
    var mostUsed: String
    var countString: String
    var emojisCount: [String: Int]
    var differentEmojisCount: Int
    var peopleReactions: [String: String]
}

struct Reply: Equatable, Hashable{
    var originID: UUID
    var text: String
    var sender: String
}

struct FormattedChar{
    let char: String
    let formats: [String]
}
let testMessageUUID: UUID = UUID()

let defaultMessages: [Message] = [Message(time: "01.01.2024 17:23", sender: "me", text: "Gute Nacht", reactions: ["me": "🙃", "you": "😆"]), Message(time: "02.01.2024 11:28", sender: "me", text: "Hey, hast du grad Zeit? Wir wollten mal noch unser Wochende planen 😅"), Message(time: "02.01.2024 11:29", sender: "you", text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", id: testMessageUUID), Message(time: "02.01.2024 11:30", sender: "you", text: "So habe ich geschaut. Es klappt. Hast du die anderen schon gefragt?"), Message(time: "02.01.2024 11:30", sender: "me", text: "Ja, die haben alle Zeit"), Message(time: "02.01.2024 11:30", sender: "me", text: "womit wollen wir anfangen?"), Message(time: "02.01.2024 11:31", sender: "you", text: "Ich würde vorschlagen das wir erstmal in ein schönes Restaurant gehen. Ich hätte das La Casa im Blick."), Message(time: "02.01.2024 11:32", sender: "me", text: "gibt es da auch was veganes auf der Speisekarte?"), Message(time: "02.01.2024 11:33", sender: "you", text: "Das", reactions: ["me": "🙃", "you": "😆"]), Message(time: "02.01.2024 11:33", sender: "you", text: "Oder war es doch Tom ?"), Message(time: "02.01.2024 11:34", sender: "you", text: "Ich bringe das grade etwas durcheinander. Vielleicht kannst du nochmal nachfragen. Du hast die Nummern von denen."), Message(time: "02.01.2024 11:35", sender: "me", text: "Anna war es. Sie verträgt kein Gluten"), Message(time: "02.01.2024 11:35", sender: "me", text: "Gut dass du dran denkst"), Message(time: "02.01.2024 11:35", sender: "me", text: "hatte ich grade garnicht auf dem schirm"), Message(time: "02.01.2024 11:36", sender: "you", text: "Perfekt, dann rufe ich dort später mal an. Soll ich noch jemanden abholen ? Und, wenn ja könntest du mir die Adressen weiterleiten ? Würde sich anbieten da sie auf dem Weg liegen und dann müssen wir nicht mit so vielen Autos fahren."), Message(time: "02.01.2024 11:38", sender: "me", text: "Ja, mich und Luca wäre super. Meine Addresse kennst du ja, Luca wohnt im Randomweg 787"), Message(time: "02.01.2024 11:39", sender: "you", text: "Alles klar. Habe ich dann jetzt direkt im Navi abgespeichert. Passt es dann Luca, wenn ich ihn als erstes abhole?"), Message(time: "02.01.2024 11:40", sender: "me", text: "Ja klar"), Message(time: "02.01.2024 11:40", sender: "you", text: "Wäre dann so um ca 18 Uhr vor seiner Haustür."), Message(time: "02.01.2024 11:40", sender: "me", text: "super, gebe ich weiter"), Message(time: "02.01.2024 11:40", sender: "me", text: "Er freut sich"), Message(time: "02.01.2024 11:41", sender: "you", text: "Perfekt, ich mich auch. Sollte noch was sein melde dich einfach."), Message(time: "02.01.2024 11:42", sender: "me", type: "reply", reply: Reply(originID: testMessageUUID, text: "Hey 👋\nSchön dass du dich meldest.\nIch würde einmal im Kalender nachsehen ob es klappt und mich dann nochmal melden.", sender: "You"), text: "Mach ich, bis dann"), Message(time: "06.01.2024 19:44", sender: "me", text: "Hallo~ ich _bin *Mia_ lol* ~Test _123_~")]

struct ContentView: View {
    @State var chats: [Chat] = [Chat(title: "Eli", participants: ["you", "me"], messages: defaultMessages)]
    
    var body: some View {
        ChatView(messages: chats[0].messages)
    }
}


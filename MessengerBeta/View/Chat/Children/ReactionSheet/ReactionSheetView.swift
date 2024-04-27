import SwiftUI

struct ReactionSheetView: View {
    //MARK: - Body
    
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(emojisSorted, id: \.self){emoji in
                        HStack{
                            Text(emoji)
                            Text("\(reaction.emojisCount[emoji]!)")
                        }
                        .padding()
                        .allowsHitTesting(false)
                        .background{
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(selected == emoji ? .ultraThinMaterial : .thickMaterial)
                                .onTapGesture(){
                                    selected = emoji
                                }
                        }
                        .padding(.leading, emoji == emojisSorted.first ? 10 : 0)
                    }
                }
            }
            .scrollIndicators(.hidden)
            Divider()
            ScrollView{
                VStack{
                    ForEach(reaction.peopleReactions.keys(forValue: selected), id: \.self){person in
                        Text("\(person)")
                    }
                }
            }
        }
        .onAppear(){
            emojisSorted = reaction.emojisCount.keys.sorted(by: {reaction.emojisCount[$0] ?? -1 > reaction.emojisCount[$1] ?? -1})
        }
    }
    
    //MARK: - Parameters
    
    @State var reaction: Reaction
    @State var selected: String = ""
    @State var emojisSorted: [String] = []
    
    //MARK: -
}

#Preview {
    @State var reaction = Reaction(mostUsed: "😀😅🤣", countString: "2000", emojisCount: ["😀": 1000, "😅": 500, "🤣": 100, "😂": 80, "🙂": 80, "🙃": 80, "🫠": 80, "😉": 80], differentEmojisCount: 8, peopleReactions: [1: "😀", 2: "😀", 3: "😀", 4: "😅", 5: "😅", 6: "😅", 7: "🤣", 8: "🤣", 9: "🤣", 10: "😂", 11: "😂", 12: "😂", 13: "🙂", 14: "🙂", 15: "🙂", 16: "🙃", 17: "🙃", 18: "🙃", 19: "🫠", 20: "🫠", 21: "🫠", 22: "😉", 23: "😉", 24: "😉"])
    return ReactionSheetView(reaction: reaction)
}

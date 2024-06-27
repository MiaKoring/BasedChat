import SwiftUI
import RealmSwift

struct ReactionSheetView: View {
    //MARK: - Body
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(emojisSorted, id: \.self) { emoji in
                        HStack {
                            Text(emoji)
                            Text("\(reaction.emojisCount[emoji]!)")
                        }
                        .padding()
                        .allowsHitTesting(false)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(selected == emoji ? .ultraThinMaterial : .thickMaterial)
                                .onTapGesture() {
                                    selected = emoji
                                }
                        }
                        .padding(.leading, emoji == emojisSorted.first ? 10 : 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            
            Divider()
            ScrollView {
                LazyVStack {
                    ForEach(0..<reaction.peopleReactions.count) { index in
                        let react = reaction.peopleReactions[index]
                        HStack {
                            Text("\(react.sender!.savedAs.isEmpty ? react.sender!.username : react.sender!.savedAs)")
                                .font(.title2)
                            Spacer()
                        }
                        if index < reaction.peopleReactions.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Parameters
    
    @State var reaction: BuiltReactions
    @State var selected: String = ""
    @State var emojisSorted: [String]
    
    //MARK: -
}


#if canImport(UIKit)
import SwiftUI
import SwiftChameleon

struct MediaControlView: View {
    @StateObject private var musicPlayerManager = MusicPlayerManager()
    
    var body: some View {
        VStack {
            if let title = musicPlayerManager.nowPlayingItem?.title {
                Text(title)
                    .lineLimit(1)
                    .padding(.bottom, 5)
                    .padding(.horizontal, 10)
            } else {
                Text("not playing")
                    .padding(.bottom, 5)
            }
            HStack(spacing: 30) {
                Image(systemName: "backward.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray.opacity(0.7))
                    .onTapGesture {
                        musicPlayerManager.skipToPreviousItem()
                    }
                if musicPlayerManager.playbackState != .playing  {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray.opacity(0.7))
                        .onTapGesture {
                            musicPlayerManager.play()
                        }
                } else {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray.opacity(0.7))
                        .onTapGesture {
                            musicPlayerManager.pause()
                        }
                }
                Image(systemName: "forward.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray.opacity(0.7))
                    .onTapGesture {
                        musicPlayerManager.skipToNextItem()
                    }
            }
        }
        .frame(maxHeight: 40)
        .alert("Error", isPresented: $musicPlayerManager.showErrorMessage, actions: {
            Button {
                guard let url = URL(string: "https://music.apple.com") else { return }
                URLHandler.open(url)
            } label: {
                Text("AppleMusic")
            }
        }, message: {
            Text(musicPlayerManager.errorMessage
                 ?? "")
        })
    }
}

#Preview {
    MediaControlView()
}

#endif

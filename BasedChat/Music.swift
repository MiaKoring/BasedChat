//
//  Music.swift
//  MessengerBeta
//
//  Created by Mia Koring on 01.01.24.
//
/*
import Foundation
import MediaPlayer
 
 let musicPlayer = MPMusicPlayerController.systemMusicPlayer
 @State private var nowPlayingItem: MPMediaItem?
 
 
Button(action: {
    if musicPlayer.playbackState == .playing || musicPlayer.playbackState == .paused{
        musicPlayer.skipToNextItem()
        print("skipped")
    }
    else{
        print("not available")
    }
}, label: {
    Text("Skip")
})
HStack{
    if let artwork = nowPlayingItem?.artwork{
        let albumArtworkImg = artwork.image(at: CGSize(width: 10, height: 10))
        if let img = albumArtworkImg {
            Image(uiImage: img)
        }
    }
    VStack{
        Text(nowPlayingItem?.title ?? "Nichts wird abgespielt")
        Text(nowPlayingItem?.artist ?? "Nichts wird abgespielt")
    }
}
.onAppear {
    // Füge den Beobachter für Änderungen des nowPlayingItem hinzu
    NotificationCenter.default.addObserver(
        forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
        object: MPMusicPlayerController.systemMusicPlayer,
        queue: nil
    ) { _ in
        self.nowPlayingItem = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem
    }
}
.onDisappear {
    // Entferne den Beobachter, wenn die Ansicht verschwindet
    NotificationCenter.default.removeObserver(self)
    MPMusicPlayerController.systemMusicPlayer.endGeneratingPlaybackNotifications()
}
*/

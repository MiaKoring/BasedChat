import SwiftUI
import MediaPlayer
import Combine
import MusicKit

class MusicPlayerManager: ObservableObject {
    @Published var nowPlayingItem: MPMediaItem? = nil
    @Published var playbackState: MPMusicPlaybackState = .stopped
    @Published var showErrorMessage: Bool = false
    @Published var errorMessage: String? = nil
    
    private var musicPlayer = MPMusicPlayerController.systemMusicPlayer
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.nowPlayingItem = musicPlayer.nowPlayingItem
        self.playbackState = musicPlayer.playbackState
        setupNotifications()
        checkMediaLibraryAuthorizationStatus()
    }
    
    deinit {
        removeNotifications()
    }
    
    func play() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            musicPlayer.play()
        } else {
            showErrorMessage("No access to media library.")
        }
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func skipToNextItem() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            musicPlayer.skipToNextItem()
        } else {
            showErrorMessage("No access to media library.")
        }
    }
    
    func skipToPreviousItem() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            musicPlayer.skipToPreviousItem()
        } else {
            showErrorMessage("No access to media library.")
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)
            .sink { [weak self] _ in
                self?.playbackState = self?.musicPlayer.playbackState ?? .stopped
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)
            .sink { [weak self] _ in
                self?.nowPlayingItem = self?.musicPlayer.nowPlayingItem
            }
            .store(in: &cancellables)
        
        musicPlayer.beginGeneratingPlaybackNotifications()
    }
    
    private func removeNotifications() {
        cancellables.removeAll()
        musicPlayer.endGeneratingPlaybackNotifications()
    }
    
    private func checkMediaLibraryAuthorizationStatus() {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
            case .authorized:
                // Authorized to access media library
                break
            case .denied, .restricted:
                showErrorMessage("Media library access denied or restricted.")
            case .notDetermined:
                MPMediaLibrary.requestAuthorization { [weak self] newStatus in
                    if newStatus != .authorized {
                        self?.showErrorMessage("Media library access denied.")
                    }
                }
            @unknown default:
                break
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showErrorMessage = true
    }
}

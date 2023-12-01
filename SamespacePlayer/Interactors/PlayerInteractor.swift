//
//  PlayerInteractor.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 28/11/23.
//

import Foundation
import SwiftUI
import AVKit


protocol PlayerInteractorType {
    func load(song: Song)
    func playPause()
    func seek(value: Double)
    func update(value: Binding<Double>)
    func updateCurrentTime() 
    func playNext(song: Song)
    func playPrev(song: Song)
}

class PlayerInteractor: PlayerInteractorType {
    let appState: Store<AppState>
    let webRepository: AudioWebRepositoryType
    var player: AVAudioPlayer?
    
    init(appState: Store<AppState>, webRepository: AudioWebRepositoryType) {
        self.appState = appState
        self.webRepository = webRepository
    }
    
    func load(song: Song) {
        appState[\.userData.isLoadingSong] = true
        appState[\.userData.playerError] = nil
        
        webRepository
            .load(url: song.url)
            .sinkToResult({ result in
                switch result {
                case .success(let data):
                    self.play(song: song, with: data)
                case .failure(_):
                    self.appState[\.userData.isLoadingSong] = false
                    self.appState[\.userData.playerError] = "Cannot play song"
                    self.playNext(song: song)
                }
            })
            .store(in: CancelBag())
        
    }
    
    private func play(song: Song, with data: Data) {
        do {
            let player = try AVAudioPlayer(data: data)
            self.player = player
            let image = ImageCache.shared.get(forKey: song.cover) ??
            UIImage(named: "defaultImage")!
            player.play()
            let playback = Playback(
                song: song,
                image: image,
                duration: player.duration,
                currentTime: player.currentTime,
                isPlaying: true
            )
            appState[\.userData.playback] = playback
        } catch {
            appState[\.userData.playerError] = "Cannot play song"
        }
        
        appState[\.userData.isLoadingSong] = false
    }
    
    func playPause() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.pause()
            appState[\.userData.playback]?.isPlaying = false
        } else {
            player.play()
            appState[\.userData.playback]?.isPlaying = true
        }
    }
    
    func seek(value: Double) {
        player?.currentTime = value
    }
    
    func update(value: Binding<Double>) {
        if let player = player {
            value.wrappedValue = player.currentTime
        }
    }
    
    func updateCurrentTime() {
        if let player = player {
            appState[\.userData.playback]?.currentTime = player.currentTime
        }
    }
    
    func playNext(song: Song) {
        let songs = appState[\.userData.songs]
        guard let index = songs.firstIndex(of: song) else { return }
        if index + 1 < songs.count {
            load(song: songs[index + 1])
            self.player?.stop()
        } else {
            load(song: songs[0])
            self.player?.stop()
        }
    }
    
    func playPrev(song: Song) {
        let songs = appState[\.userData.songs]
        guard let index = songs.firstIndex(of: song) else { return }
        if index - 1 >= 0 {
            load(song: songs[index - 1])
            self.player?.stop()
        } else {
            load(song: songs[songs.count - 1])
            self.player?.stop()
        }
    }
}

struct StubPlayerInteractor: PlayerInteractorType {
    func load(song: Song) { }
    func playPause() { }
    func seek(value: Double) { }
    func update(value: Binding<Double>) { }
    func updateCurrentTime() { }
    func playNext(song: Song) { }
    func playPrev(song: Song) { }
}

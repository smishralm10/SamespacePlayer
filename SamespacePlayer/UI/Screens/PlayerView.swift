//
//  ExpandedPlayer.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 28/11/23.
//

import SwiftUI
import Combine

struct PlayerView: View {
    @State private(set) var playbackProgress = 0.0
    @State private(set) var offsetY: CGFloat = 0
    @State private(set) var playback: Playback? = nil
    @State private(set) var isEditing = false
    @State private(set) var isLoading = false
    @State private(set) var error: String? = nil
    
    let timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.injected) var injected
    
    init(playback: Playback? = nil) {
        self._playback = .init(initialValue: playback)
        self._playbackProgress = .init(initialValue: playback?.currentTime ?? 0)
    }
    
    var body: some View {
        mainView()
            .onReceive(playbackUpdate) { playback = $0 }
            .onReceive(timer) { _ in
                if !isEditing {
                    updateCurrentTime()
                }
            }
    }
    
    @ViewBuilder
    private func mainView() -> some View {
        if let playback = playback {
            GeometryReader {
                let size = $0.size
                VStack {
                    Spacer()
                    Capsule()
                        .fill(.secondary)
                        .frame(width: 40, height: 5)
                    
                    Spacer()
                    
                    Image(uiImage: playback.image)
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width * 0.8,
                            height: UIScreen.main.bounds.width * 0.8
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 5,
                                style: .continuous
                            )
                        )
                        .padding(.vertical)
                    
                    
                    playerView(playback: playback)
                    
                }
                .background(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [playback.song.accent, .black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
                )
                .offset(y: offsetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let translationY = value.translation.height
                            offsetY = (translationY > 0 ? translationY : 0)
                        })
                        .onEnded({ value in
                            withAnimation(.spring(duration: 0.3)) {
                                if offsetY > size.height * 0.4 {
                                    dismiss()
                                } else {
                                    offsetY = .zero
                                }
                            }
                        })
                )
            }
        }
    }
    
    private func playerView(playback: Playback) -> some View {
        VStack {
            VStack(spacing: 5) {
                Text(playback.song.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(playback.song.artist)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical)
            // Player Controls
            playerControls(playback: playback)
        }
        .padding()
    }
    
    private func playerControls(playback: Playback) -> some View {
        VStack {
            Spacer()
            Slider(value: $playbackProgress, in: 0...playback.duration) { editing  in
                isEditing = editing
                if !editing {
                    seek(value: playbackProgress)
                }
            }
            
            HStack {
                Text(playbackProgress.toMinutesAndSeconds)
                    .font(.footnote)
                    .foregroundStyle(.primary)
                Spacer()
                Text(playback.duration.toMinutesAndSeconds)
                    .font(.footnote)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    playPrev(song: playback.song)
                } label: {
                    Image(systemName: "backward.fill")
                        
                }
                .font(.system(size: 40))
                
                Spacer()
                
                Button {
                    playPause()
                } label: {
                    if playback.isPlaying {
                        Image(systemName: "pause.circle.fill")
                    } else {
                        Image(systemName: "play.circle.fill")
                    }
                }
                .font(.system(size: 64))
                
                Spacer()
                
                Button {
                    playNext(song: playback.song)
                } label: {
                    Image(systemName: "forward.fill")
                }
                .font(.system(size: 40))
                
                Spacer()
            }
            Spacer()
        }
    }
}

// MARK: - Side Effects
private extension PlayerView {
    func playPause() {
        injected.interactors
            .playerInteractor
            .playPause()
    }
    
    func updateCurrentTime() {
        injected.interactors
            .playerInteractor
            .update(value: $playbackProgress)
    }
    
    func seek(value: Double) {
        injected.interactors
            .playerInteractor
            .seek(value: value)
    }
    
    func playNext(song: Song) {
        injected.interactors
            .playerInteractor
            .playNext(song: song)
    }
    
    func playPrev(song: Song) {
        injected.interactors
            .playerInteractor
            .playPrev(song: song)
    }
}

// MARK: - State Updates
private extension PlayerView {
    var playbackUpdate: AnyPublisher<Playback?, Never> {
        injected.appState.updates(for: \.userData.playback)
    }
}

#Preview {
    PlayerView()
        .preferredColorScheme(.dark)
}

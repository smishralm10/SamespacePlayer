//
//  MiniPlayerView.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 28/11/23.
//

import SwiftUI
import Combine

struct MiniPlayerView: View {
    @State private(set) var playback: Playback? = nil
    @State private(set) var isLoading = false
    @State private(set) var error: String? = nil
    @State private(set) var showPlayer = false
    
    @Environment(\.injected) var injected
    
    var body: some View {
        mainView()
            .fullScreenCover(isPresented: $showPlayer) {
                PlayerView(playback: playback)
            }
            .onReceive(isLoadingUpdate) { isLoading = $0 }
            .onReceive(playerErrorUpdate) { error = $0 }
            .onReceive(playbackUpdate) { playback = $0 }
    }
}

private extension MiniPlayerView {
    @ViewBuilder
    func mainView() -> some View {
        if let playback = playback {
            HStack {
                ZStack {
                    GeometryReader { proxy in
                        let size = proxy.size
                        Image(uiImage: playback.image)
                            .resizable()
                            .frame(width: size.width, height: size.height)
                            .clipShape(Circle())
                    }
                }
                .frame(width: 45, height: 45)
                
                if let error = error {
                    Text(error)
                } else {
                    Text(playback.song.name)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .padding(.horizontal, 15)
                }
                Spacer(minLength: 0)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    playPauseButton(isPlaying: playback.isPlaying)
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal)
            .frame(height: 64)
            .background(playback.song.accent)
            .contentShape(Rectangle())
            .offset(y: -70)
            .onTapGesture {
                updateCurrentTime()
                showPlayer = true
            }
        }
    }
    
    @ViewBuilder
    private func playPauseButton(isPlaying: Bool) -> some View {
        if isPlaying {
            Button {
                playPause()
            } label: {
                Image(systemName: "pause.circle.fill")
                    .foregroundStyle(.primary)
                    .font(.title)
            }
            
        } else {
            Button {
                playPause()
            } label: {
                Image(systemName: "play.circle.fill")
                    .foregroundStyle(.primary)
                    .font(.title)
            }
        }
    }
}

// MARK: - Side Effects
private extension MiniPlayerView {
    func playPause() {
        injected.interactors
            .playerInteractor
            .playPause()
    }
    
    func updateCurrentTime() {
        injected.interactors
            .playerInteractor
            .updateCurrentTime()
    }
}

// MARK: -  State Updates
private extension MiniPlayerView {
    var isLoadingUpdate: AnyPublisher<Bool, Never> {
        injected.appState.updates(for: \.userData.isLoadingSong)
    }
    
    var playerErrorUpdate: AnyPublisher<String?, Never> {
        injected.appState.updates(for: \.userData.playerError)
    }
    
    var playbackUpdate: AnyPublisher<Playback?, Never> {
        injected.appState.updates(for: \.userData.playback)
    }
}

#Preview {
    MiniPlayerView()
}

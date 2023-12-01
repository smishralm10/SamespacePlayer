//
//  TopTrack.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 29/11/23.
//

import SwiftUI
import Combine

struct TopTrack: View {
    @State private(set) var songs = [Song]()
    @State private(set) var playback: Playback? = nil
    
    @Environment(\.injected) var injected
    
    var body: some View {
        let songs = songs.filter { $0.topTrack }
        List(songs, id: \.id) { song in
            SongCell(song: song)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    injected
                        .interactors
                        .playerInteractor
                        .load(song: song)
                }
        }
        .padding(.bottom, playback != nil ? 64 : 0)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .onReceive(songsUpdate) { self.songs = $0 }
        .onReceive(playbackUpdate) { playback = $0 }
    }
}

// MARK: - State Updates
private extension TopTrack {
    var songsUpdate: AnyPublisher<[Song], Never> {
        injected.appState.updates(for: \.userData.songs)
    }
    
    var playbackUpdate: AnyPublisher<Playback?, Never> {
        injected.appState.updates(for: \.userData.playback)
    }
}

#Preview {
    TopTrack()
}

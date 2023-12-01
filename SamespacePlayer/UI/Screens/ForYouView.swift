//
//  ForYouView.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import SwiftUI
import Combine

struct ForYouView: View {
    @State private(set) var songs: Loadable<[Song]>
    @State private(set) var playback: Playback? = nil
    @Environment(\.injected) var injected
    
    init(songs: Loadable<[Song]> = .notRequested) {
        self._songs = .init(initialValue: songs)
    }
    
    var body: some View {
        content
            .toolbarBackground(.hidden, for: .tabBar)
            .background(.background)
            .onReceive(playbackUpdate) { playback = $0 }
    }
    
    @ViewBuilder private var content: some View {
        switch songs {
        case .notRequested:
            notRequestView
        case let .isLoading(last, _):
            loadingView(last)
        case let .loaded(songs):
            loadedView(songs, isLoading: false)
        case let .failed(error):
            Text(error.localizedDescription)
        }
    }
    
}
    
// MARK: - Side Effects
private extension ForYouView {
    func loadSongs() {
        injected
            .interactors
            .songInteractor
            .load(songs: $songs)
    }
    
    func playSong(song: Song) {
        injected
            .interactors
            .playerInteractor
            .load(song: song)
            
    }
}

// MARK: - Loading Content
private extension ForYouView {
    var notRequestView: some View {
        Color.clear
            .onAppear(perform: loadSongs)
    }
    
    func loadingView(_ previouslyLoaded: [Song]?) -> some View {
        if let last = previouslyLoaded {
            return AnyView(
                loadedView(last, isLoading: true)
            )
        } else {
            return AnyView(
                ProgressView()
                    .progressViewStyle(.circular)
            )
        }
    }
}

// MARK: - Displaying Content
private extension ForYouView {
    func loadedView(_ songs: [Song], isLoading: Bool) -> some View {
        VStack {
            List(songs, id: \.id) { song in
                SongCell(song: song)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        playSong(song: song)
                    }
            }
            .padding(.bottom, playback != nil ? 64 : 0)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
    }
}

private extension ForYouView {
    var playbackUpdate: AnyPublisher<Playback?, Never> {
        injected.appState.updates(for: \.userData.playback)
    }
}

#Preview {
    ForYouView(songs: .loaded(Song.mockedData))
        .inject(.preview)
}

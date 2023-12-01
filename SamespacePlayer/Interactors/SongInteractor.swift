//
//  ForYouInteractor.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 24/11/23.
//

import Foundation

protocol SongInteractorType {
    func load(songs: LoadableSubject<[Song]>)
}

struct SongInteractor: SongInteractorType {
    let appState: Store<AppState>
    let songWebRepository: SongWebRepositoryType
    
    func load(songs: LoadableSubject<[Song]>) {
        let cancelBag = CancelBag()
        songs.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        songWebRepository
            .loadSongs()
            .sinkToLoadable {
                songs.wrappedValue = $0
                self.appState[\.userData.songs] = $0.value ?? []
            }
            .store(in: cancelBag)
    }
}

struct StubSongInteractor: SongInteractorType {
    func load(songs: LoadableSubject<[Song]>) { }
}

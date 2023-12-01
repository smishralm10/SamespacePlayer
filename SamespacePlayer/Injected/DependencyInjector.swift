//
//  DIContainer.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 24/11/23.
//

import Foundation
import SwiftUI
import Combine

struct DIContainer: EnvironmentKey {
    let appState: Store<AppState>
    let interactors: Interactors
    
    init(appState: Store<AppState>, interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
    
    init(appState: AppState, interactors: Interactors) {
        self.init(appState: Store<AppState>(appState), interactors: interactors)
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(appState: AppState(), interactors: .stub)
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self]  = newValue }
    }
}


#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(appState: .init(AppState.preview), interactors: .stub)
    }
}
#endif

extension DIContainer {
    struct Interactors {
        let songInteractor: SongInteractorType
        let imageInteractor: ImageInteractorType
        let playerInteractor: PlayerInteractorType
        
        static var stub: Self {
            .init(
                songInteractor: StubSongInteractor(),
                imageInteractor: StubImageInteractor(),
                playerInteractor: StubPlayerInteractor()
            )
        }
    }
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        return environment(\.injected, container)
    }
}

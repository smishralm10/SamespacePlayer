//
//  AppEnvironment.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 24/11/23.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        let session = configuredURLSession()
        let webRepositories = configuredWebRespositories(session: session)
        let interactors = configuredInteractors(
            appState: appState,
            webRepositories: webRepositories
        )
        
        let diContainer = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    private static func configuredWebRespositories(session: URLSession) -> DIContainer.WebRepositories {
        let songWebRepository = SongWebRepository(
            session: session,
            baseURL: "https://cms.samespace.com"
        )
        
        let imageWebRepository = ImageWebRepository(
            session: session,
            baseURL: "https://cms.samespace.com/assets"
        )
        
        let audioWebRepository = AudioWebRepository(
            session: session,
            baseURL: ""
        )
        
        return .init(
            songWebRepository: songWebRepository,
            imageWebRepository: imageWebRepository,
            audioWebRepository: audioWebRepository
        )
    }
    
    private static func configuredInteractors(
        appState: Store<AppState>,
        webRepositories: DIContainer.WebRepositories
    ) -> DIContainer.Interactors {
        let songInteractor = SongInteractor(
            appState: appState,
            songWebRepository: webRepositories.songWebRepository
        )
        let imageInteractor = ImageInteractor(webRepository: webRepositories.imageWebRepository)
        let playerInteractor = PlayerInteractor(
            appState: appState,
            webRepository: webRepositories.audioWebRepository
        )
        
        return .init(
            songInteractor: songInteractor,
            imageInteractor: imageInteractor,
            playerInteractor: playerInteractor
        )
    }
}


extension DIContainer {
    struct WebRepositories {
        let songWebRepository: SongWebRepositoryType
        let imageWebRepository: ImageWebRepositoryType
        let audioWebRepository: AudioWebRepositoryType
    }
}

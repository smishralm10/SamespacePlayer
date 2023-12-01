//
//  SongWebRepository.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import Foundation
import Combine

protocol SongWebRepositoryType: WebRepository {
    func loadSongs() -> AnyPublisher<[Song], Error>
}

struct SongWebRepository: SongWebRepositoryType {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func loadSongs() -> AnyPublisher<[Song], Error> {
        let request: AnyPublisher<Songs, Error> = call(endpoint: API.allSongs)
        return request
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

extension SongWebRepository {
    enum API {
        case allSongs
    }
}

extension SongWebRepository.API: APICall {
    var path: String {
        switch self {
        case .allSongs: "/items/songs"
        }
    }
    var method: String { "GET" }
    var headers: [String : String]? {
        ["Accept": "application/json"]
    }
    func body() throws -> Data? {
        nil
    }
}

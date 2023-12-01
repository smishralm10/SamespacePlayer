//
//  AudioRepository.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 28/11/23.
//

import Foundation
import Combine

protocol AudioWebRepositoryType: WebRepository {
    func load(url: URL) -> AnyPublisher<Data, Error>
}

struct AudioWebRepository: AudioWebRepositoryType {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_queue")
    
    func load(url: URL) -> AnyPublisher<Data, Error> {
        let urlRequest = URLRequest(url: url)
        return session.dataTaskPublisher(for: urlRequest)
            .requestData()
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    }
    
}


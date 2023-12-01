//
//  ImageWebRepository.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 25/11/23.
//

import Combine
import UIKit.UIImage


protocol ImageWebRepositoryType: WebRepository {
    func load(cover: String) -> AnyPublisher<UIImage, Error>
}

struct ImageWebRepository: ImageWebRepositoryType {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_queue")
    
    func load(cover: String) -> AnyPublisher<UIImage, Error> {
        guard let imageURL = URL(string: baseURL)?.appending(path: cover) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return download(imageURL: imageURL)
            .subscribe(on: bgQueue)
            .receive(on: DispatchQueue.main)
            .extractUnderlyingError()
            .eraseToAnyPublisher()
    }
    
    private func download(imageURL: URL) -> AnyPublisher<UIImage, Error> {
        let urlRequest = URLRequest(url: imageURL)
        return session.dataTaskPublisher(for: urlRequest)
            .requestData()
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw APIError.imageDeserialization
                }
                return image
            }
            .eraseToAnyPublisher()
    }
}

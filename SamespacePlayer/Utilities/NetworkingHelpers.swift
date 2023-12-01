//
//  NetworkingHelpers.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 24/11/23.
//

import Foundation
import Combine

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default: break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
    
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        return sink { subscriptionCompletion in
            if let error = subscriptionCompletion.error {
                completion(.failed(error))
            }
        } receiveValue: { value in
            completion(.loaded(value))
        }
    }
}

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): error
        default: nil
        }
    }
}

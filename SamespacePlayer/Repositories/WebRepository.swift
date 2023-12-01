//
//  WebRepository.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import Foundation
import Combine

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
    var bgQueue: DispatchQueue { get }
}

extension WebRepository {
    func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error> where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }
}


// MARK: - Helpers
extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestData(httpCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
        return tryMap {
            assert(!Thread.isMainThread)
            guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                throw APIError.unexpectedResponse
            }
            
            guard httpCodes.contains(code) else {
                throw APIError.httpCode(code)
            }
            
            return $0.0
        }
        .extractUnderlyingError()
        .eraseToAnyPublisher()
    }
}


extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return requestData(httpCodes: httpCodes)
            .decode(type: Value.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            // Offline
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}


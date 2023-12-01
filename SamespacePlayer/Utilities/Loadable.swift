//
//  Loadable.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import Foundation
import SwiftUI

typealias LoadableSubject<Value> = Binding<Loadable<Value>>

enum Loadable<T> {
    case notRequested
    case isLoading(last: T?, cancelBag: CancelBag)
    case loaded(T)
    case failed(Error)
    
    var value: T? {
        switch self {
        case let .isLoading(last, _): last
        case let .loaded(value): value
        default: nil
        }
    }
    
    var error: Error? {
        switch self {
        case let .failed(error): error
        default: nil
        }
    }
}

extension Loadable {
    mutating func setIsLoading(cancelBag: CancelBag) {
        self = .isLoading(last: value, cancelBag: cancelBag)
    }
}

extension Loadable: Equatable where T: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): true
        case let (.isLoading(lhsV, lhsC), .isLoading(rhsV, rhsC)):
            lhsV == rhsV && lhsC.isEqual(to: rhsC)
        case let (.failed(lhsE), .failed(rhsE)):
            lhsE.localizedDescription == rhsE.localizedDescription
        default: false
        }
    }
}

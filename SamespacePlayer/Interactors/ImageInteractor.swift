//
//  ImageInteractor.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 25/11/23.
//

import Foundation
import Combine
import SwiftUI

protocol ImageInteractorType {
    func load(image: LoadableSubject<UIImage>, cover: String)
}

struct ImageInteractor: ImageInteractorType {
    let webRepository: ImageWebRepositoryType
    
    func load(image: LoadableSubject<UIImage>, cover: String) {
        let cancelBag = CancelBag()
        image.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        if let cachedImage = ImageCache.shared.get(forKey: cover) {
            image.wrappedValue = .loaded(cachedImage)
            return
        }
        
        webRepository
            .load(cover: cover)
            .map { image in
                ImageCache.shared.set(image, forKey: cover)
                return image
            }
            .sinkToLoadable {
                image.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
}

struct StubImageInteractor: ImageInteractorType {
    func load(image: LoadableSubject<UIImage>, cover: String) { }
}

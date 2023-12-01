//
//  ImageView.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 25/11/23.
//

import SwiftUI

struct ImageView: View {
    let cover: String
    @State private(set) var image: Loadable<UIImage>
    @Environment(\.injected) private var injected
    
    init(cover: String, image: Loadable<UIImage> = .notRequested) {
        self.cover = cover
        self._image = .init(initialValue: image)
    }
    
    var body: some View {
       content
    }
    
    @ViewBuilder private var content: some View {
        switch image {
        case .notRequested:
            notRequestedView
        case .isLoading(_, _):
            loadingView
        case let .loaded(uiImage):
            loadedView(uiImage)
        case .failed(_):
            failedView()
        }
    }
}

// MARK: - Side Effects
private extension ImageView {
    func loadImage() {
        injected
            .interactors
            .imageInteractor
            .load(image: $image, cover: cover)
    }
}

// MARK: - Loading View
private extension ImageView {
    var notRequestedView: some View {
        Color.clear
            .onAppear(perform: loadImage)
    }
    
    var loadingView: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }
}

// MARK: Displaying Content
private extension ImageView {
    func loadedView(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    func failedView() -> some View {
        Circle()
            .fill(.gray)
            .frame(width: 48)
    }
}

#Preview {
    ImageView(cover: "")
}

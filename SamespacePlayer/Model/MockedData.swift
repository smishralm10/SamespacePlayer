//
//  MockedData.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import Foundation
import SwiftUI

#if DEBUG

extension Song {
    static let mockedData: [Song] = [
        .init(
            id: 1,
            name: "Colors",
            artist: "William King",
            accent: Color(hex: "#331E00")!,
            cover: "4f718272-6b0e-42ee-92d0-805b783cb471",
            topTrack: true,
            url: URL(string: "https://pub-172b4845a7e24a16956308706aaf24c2.r2.dev/august-145937.mp3")!
        )
    ]
}

#endif

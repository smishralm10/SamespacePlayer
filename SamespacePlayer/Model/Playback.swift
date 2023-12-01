//
//  Playback.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 29/11/23.
//

import Foundation
import UIKit.UIImage

struct Playback {
    var song: Song
    var image: UIImage
    var duration: TimeInterval
    var currentTime: TimeInterval
    var isPlaying = false
}

extension Playback: Equatable {
    static func == (lhs: Playback, rhs: Playback) -> Bool {
        (lhs.song.id == rhs.song.id &&
         lhs.duration == rhs.duration &&
         lhs.currentTime == rhs.currentTime &&
         lhs.isPlaying == rhs.isPlaying)
    }
}

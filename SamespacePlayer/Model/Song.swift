//
//  Song.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import Foundation
import SwiftUI

struct Songs: Decodable {
    let data: [Song]
    
    enum CodingKeys: CodingKey {
        case data
    }
}

struct Song: Decodable {
    let id: Int
    let name: String
    let artist: String
    let accent: Color
    let cover: String
    let topTrack: Bool
    let url: URL
    
    enum CodkingKeys: String, CodingKey {
        case id
        case name
        case artist
        case accent
        case cover
        case topTrack = "top_track"
        case url
    }
    
    init(
        id: Int,
        name: String,
        artist: String,
        accent: Color,
        cover: String,
        topTrack: Bool,
        url: URL
    ) {
        self.id = id
        self.name = name
        self.artist = artist
        self.accent = accent
        self.cover = cover
        self.topTrack = topTrack
        self.url = url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodkingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(String.self, forKey: .artist)
        let hexString = try container.decode(String.self, forKey: .accent)
        if let color = Color(hex: hexString) {
            self.accent = color
        } else {
            self.accent = .primary
        }
        self.cover = try container.decode(String.self, forKey: .cover)
        self.topTrack = try container.decode(Bool.self, forKey: .topTrack)
        self.url = try container.decode(URL.self, forKey: .url)
    }
}

extension Song: Equatable {
    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }
}

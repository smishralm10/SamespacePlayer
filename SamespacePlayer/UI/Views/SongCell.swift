//
//  SongCell.swift
//  SamespacePlayer
//
//  Created by Shreyansh Mishra on 23/11/23.
//

import SwiftUI

struct SongCell: View {
    let song: Song
    
    var body: some View {
        HStack {
            ImageView(cover: song.cover)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(song.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
        }
        .background(.background)
        .padding(.vertical, 4)
    }
}

#Preview {
    SongCell(song: Song.mockedData[0])
        .inject(.preview)
}

//
//  PlaylistData.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 17/11/2024.
//

import Foundation

struct Track: Codable {
    let title: String
    let artist: String
    let duration: String
}

struct Playlist: Codable {
    let type: PlaylistType
    let title: String
    let description: String
    let imageName: String
    let tracks: [Track]
}

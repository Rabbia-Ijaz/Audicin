//
//  PlaylistType.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 17/11/2024.
//

import Foundation

enum PlaylistType: String, Codable {
    case relaxing = "relaxing"
    case focused = "focused"
    case energizing = "energizing"
    case all = "all"
    
    var title: String {
        switch self {
        case .relaxing:
            return "Relaxing Playlist"
        case .focused:
            return "Focused Playlist"
        case .energizing:
            return "Energizing Playlist"
        case .all:
            return "All Kinds of Music"
        }
    }
    
    var description: String {
        switch self {
        case .relaxing:
            return "Unwind and relax with this calming playlist."
        case .focused:
            return "Stay focused and productive with these tracks."
        case .energizing:
            return "Boost your energy with upbeat tunes!"
        case .all:
            return "A diverse mix of the best tracks from every genre. Whether you're into relaxed, focused, or energizing music, this playlist has something for everyone."
        }
    }
    
}

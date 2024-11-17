//
//  PlaylistViewModel.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 17/11/2024.
//

import Foundation
import HealthKit



class PlaylistViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var todayStepCount: Int = 0
    
    private let manager = StepCountManager()
    private let healthKitManager = HealthKitManager()
    
    func loadPlaylists() {
        guard let url = Bundle.main.url(forResource: "playlists", withExtension: "json") else {
            print("Error: playlists.json not found in the bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let playlistData = try JSONDecoder().decode([Playlist].self, from: data)
            self.playlists = playlistData
        } catch {
            print("Error decoding playlists.json: \(error)")
        }
    }
 
    func loadTodayStepCount() {
        manager.fetchTodayStepCount { [weak self] stepCount, error in
            DispatchQueue.main.async {
                if let stepCount = stepCount {
                    self?.todayStepCount = stepCount
                } else {
                    print(error)
                }
            }
        }
    }
    
    func playlistForStepCount() -> PlaylistType {
        loadTodayStepCount()
        switch todayStepCount {
        case 0..<5000:
            return .relaxing
        case 5000..<11000:
            return .focused
        default:
            return .energizing
        }
    }
}

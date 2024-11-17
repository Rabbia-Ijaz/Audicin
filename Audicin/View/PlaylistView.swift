//
//  StepCountView.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 16/11/2024.
//

import SwiftUI


struct PlaylistView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = PlaylistViewModel()
    @State private var playlistChoice: PlaylistType?
    @State private var filteredPlaylist: Playlist?
    @State private var filteredTracks: [Track]?
    
    var body: some View {
        ZStack{
            Color("customYellow").opacity(0.2).ignoresSafeArea()
            VStack() {
                VStack(spacing:5) {
                    Text(playlistChoice?.title ?? "")
                        .font(.system(size: 24, weight: .black))
                        .foregroundStyle(Color.customDarkBlue)
                    Text(playlistChoice?.description ?? "")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(Color.customDarkBlue)
                        .multilineTextAlignment(.center)
                }
                .padding(.top,20)
                .padding(.horizontal,20)
                
                playlistView
                
                refreshPlaylist

                Spacer()
                
                browseAllPlaylists
            }
        }
        .onAppear() {
            viewModel.loadPlaylists()
            updateStepCount()
        }
        .onChange(of: playlistChoice) {
            updateFilteredPlaylist()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            updateStepCount() // Refresh progress when app enters the foreground
        }
        .onChange(of: viewModel.todayStepCount) {
            updateStepCount() // Update progress when today's step count changes
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text("Back")
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(Color.customYellow1)
                    }
                    .frame(height: 40)
                    .padding(.horizontal,15)
                    .background(Color.customBlue)
                    .cornerRadius(20)
                }
            }
        }
    }
    
    var playlistView: some View {
        ScrollView {
            VStack(spacing: 15) {
                if let playlist = filteredTracks {
                    ForEach(playlist, id: \.title) {
                        track in
                        Button(action: {
                            //
                        }, label: {
                            HStack(alignment: .top) {
                                
                                Image(systemName: "music.note")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(20)
                                    .frame(width: 80,height: 80)
                                    .foregroundStyle(Color.customYellow1)
                                    .background(Color.customPink)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(track.title)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(Color.customDarkBlue)
                                    Text("Artist: \(track.artist)")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundStyle(Color.customDarkBlue)
                                    
                                }
                                Spacer()
                                Text(track.duration)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(Color.customDarkBlue)
                            }
                            .padding(.horizontal,20)
                        })
                    }
                } else {
                    Text("No Playlist Available")
                        .foregroundStyle(Color.customDarkBlue)
                }
                
            }
            .padding(.top,50)
        }
    }
    
    var refreshPlaylist: some View {
        Button(action: {
            updateStepCount()
        }, label: {
            Image(systemName: "arrow.clockwise.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .foregroundStyle(Color.customDarkBlue)
                .background(.clear)
        })
    }
    
    var browseAllPlaylists: some View {
        Button(action: {
            playlistChoice = .all
        }, label: {
            HStack {
                Image(systemName: "music.note")
                    .foregroundStyle(Color.customYellow1)
                Text("Browse All Playlists")
                    .font(.system(size: 20, weight: .black))
                    .foregroundStyle(Color.customYellow1)
                
            }
            .frame(height: 54)
            .padding(.horizontal,20)
            .background(Color.customBlue)
            .cornerRadius(27)
        })
        .padding(.bottom,30)
    }
    
// MARK: Functions
    private func updateFilteredPlaylist() {
        if playlistChoice == .all {
            filteredTracks = viewModel.playlists.flatMap{$0.tracks}
        } else {
            filteredTracks = viewModel.playlists.first(where: { $0.type.rawValue == playlistChoice?.rawValue })?.tracks
        }
    }
    private func updateStepCount() {
        playlistChoice = viewModel.playlistForStepCount()
    }
}

#Preview {
    PlaylistView()
}

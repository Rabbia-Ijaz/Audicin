//
//  TrackView.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 17/11/2024.
//

import SwiftUI

struct TrackView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var chosenTrack: Track
    @State private var isPlaying = false
    
    @State private var playbackProgress: Double = 0.0 // Track the playback progress
    private var trackDuration: TimeInterval // Duration in seconds
    @State private var currentTimeInterval: TimeInterval = 0
    
    init(chosenTrack: Track) {
        self._chosenTrack = State(initialValue: chosenTrack)
        // Convert duration string (MM:SS) to TimeInterval (seconds)
        self.trackDuration = TrackView.durationFromString(chosenTrack.duration)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("customYellow").opacity(0.2).ignoresSafeArea()
                
                VStack {
                    // Track Information
                    VStack(spacing: 5) {
                        Text(chosenTrack.title)
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(Color.customDarkBlue)
                        Text(chosenTrack.artist)
                            .font(.system(size: 20, weight: .light))
                            .foregroundStyle(Color.customDarkBlue)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Simulated Music Note Image
                    Image(systemName: "music.note")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .frame(width: 250, height: 250)
                        .foregroundStyle(Color.customYellow1)
                        .background(Color.customPink)
                        .cornerRadius(20)
                    Spacer()
                    
                    
                    progressBar
                    
                    Spacer()
                }
            }
            .onAppear {
                if isPlaying {
                    simulatePlayback()
                }
            }
            
            .navigationBarBackButtonHidden(true)
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
                        .padding(.horizontal, 15)
                        .background(Color.customBlue)
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
    
    var progressBar: some View {
        VStack {
            HStack {
                Text(secondsToTimeString(seconds: currentTimeInterval))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.customDarkBlue)
                Spacer()
                Text(secondsToTimeString(seconds: trackDuration))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.customDarkBlue)
            }
            .padding(.horizontal, 20)
            
            ProgressBar(value: $playbackProgress)
                .frame(height: 7)
                .padding(.horizontal, 20)
            
            HStack {
                // Play/Pause Button
                Button(action: togglePlayback) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .foregroundStyle(Color.customDarkBlue)
                        .background(.clear)
                }
                
                // Restart Button
                Button(action: restartPlayback) {
                    Image(systemName: "restart.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .foregroundStyle(Color.customDarkBlue)
                        .background(.clear)
                }
            }
            .padding(.top, 20)
        }
    }

    private func togglePlayback() {
        isPlaying.toggle()
        if isPlaying {
            simulatePlayback() // Start the progress simulation when playing
        }
    }

    private func restartPlayback() {
        isPlaying = false
        currentTimeInterval = 0.0
        playbackProgress = 0.0
        simulatePlayback()
    }
    
    private func simulatePlayback() {
        guard isPlaying else { return }
        
        // Simulate playback progress (every 0.1 seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.isPlaying {
                self.currentTimeInterval += 0.1 // Progress increment (e.g., 0.1 seconds)
                self.playbackProgress = self.currentTimeInterval / self.trackDuration // Update the progress
                
                // Ensure the progress stays within bounds (0.0 to 1.0)
                if self.currentTimeInterval >= self.trackDuration {
                    self.currentTimeInterval = 0
                    self.playbackProgress = 0.0 // Max progress
                    self.isPlaying = false // Stop playback once it's complete
                } else {
                    self.simulatePlayback() // Keep simulating
                }
            }
        }
    }

    // (MM:SS) to (seconds)
    private static func durationFromString(_ duration: String) -> TimeInterval {
        let components = duration.split(separator: ":")
        guard components.count == 2,
              let minutes = Double(components[0]),
              let seconds = Double(components[1]) else {
            return 0
        }
        return minutes * 60 + seconds
    }
    // (seconds) to (MM:SS)
    func secondsToTimeString(seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// ProgressBar View
struct ProgressBar: View {
    @Binding var value: Double
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.customBlue.opacity(0.3))
            Capsule()
                .fill(Color.customBlue)
                .frame(width: getValidWidth()) // Adjust width based on progress
        }
        .animation(.linear(duration: 0.1), value: value) 
        
    }
    private func getValidWidth() -> CGFloat {
        // Ensure the width is valid (non-negative and within bounds)
        let availableWidth = UIScreen.main.bounds.width - 40
        let calculatedWidth = CGFloat(value) * availableWidth
        return max(0, min(calculatedWidth, availableWidth)) // Ensure it's between 0 and availableWidth
    }
}

#Preview {
    TrackView(chosenTrack: Track(title: "Evening Serenity", artist: "Meditative Sounds", duration: "0:10"))
}

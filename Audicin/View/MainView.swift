//
//  ContentView.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 15/11/2024.
//

import SwiftUI
import Charts

struct MainView: View {

    @StateObject private var viewModel = MainViewModel()
    @State private var isNavigateToPlaylist = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color("customYellow").opacity(0.2).ignoresSafeArea()
                VStack(spacing: 10) {
                    Spacer()
                    
                    stepsProgressView
                    
                    Spacer()
                    
                    averageStepsView
                    
                    VStack {
                        if !viewModel.weeklyStepCounts.isEmpty {
                            chartView
                        } else if let error = viewModel.error {
                            Text("Error: \(error.localizedDescription)")
                        } else {
                            ProgressView("Loading step data...")
                        }
                    }
                    Button(action: {
                        isNavigateToPlaylist = true
                    }, label: {
                        HStack {
                            Image(systemName: "music.note")
                                .foregroundStyle(Color.customYellow1)
                            Text("Play Music")
                                .font(.system(size: 20, weight: .black))
                                .foregroundStyle(Color.customYellow1)
                            
                        }
                        .frame(height: 54)
                        .padding(.horizontal,20)
                        .background(Color.customBlue)
                        .cornerRadius(27)
                    })
                    .padding(.top,30)
                    
                    Spacer()
                    
                }
            }
            
            .navigationDestination(isPresented: $isNavigateToPlaylist) {
                PlaylistView()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                updateProgress() // Refresh progress when app enters the foreground
            }
            .onChange(of: viewModel.todayStepCount) {
                updateProgress() // Update progress when today's step count changes
            }
            .onChange(of: viewModel.weeklyStepCounts) {
                updateProgress() // Update progress when weekly step counts change
            }
            .onAppear {
                updateProgress()
            }
        }
    }
    
    
    var stepsProgressView: some View {
        ZStack {
            Circle()
                .stroke(Color.customBlue.opacity(0.2), lineWidth: 20) // Background circle
            Circle()
                .trim(from: 0.0, to: viewModel.progress) // Trim based on progress
                .stroke(Color.customBlue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeInOut, value: viewModel.progress) // Animate changes
            
            VStack(spacing: 10) {
                Image(systemName: "figure.walk")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .foregroundStyle(.customPink)
                
                Text("\(viewModel.todayStepCount)")
                    .font(.system(size: 50, weight: .black))
                    .foregroundStyle(.customPink)
                Text("Goal \(viewModel.averageSteps) Steps")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.customDarkBlue)
            }
        }
        .frame(width: 250, height: 250)
    }
    
    var averageStepsView: some View {
       HStack {
            VStack(alignment: .leading,spacing: 5) {
                Text("Avg")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.customDarkBlue)
                HStack(alignment:.bottom){
                    Text("\(viewModel.averageSteps)")
                        .font(.system(size: 26, weight: .black))
                        .foregroundStyle(Color.customDarkBlue)
                    Text("steps in this week")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.customDarkBlue)
                }
            }
            Spacer()
            
        }.padding(.horizontal,40)
    }
    
    var chartView: some View {
        Chart {
            ForEach(viewModel.weeklyStepCounts.sorted(by: { $0.key < $1.key }), id: \.key) { date, steps in
                BarMark(
                    x: .value("Day", date.formatted(.dateTime.weekday(.abbreviated))),
                    y: .value("Steps", steps)
                )
                .foregroundStyle(steps >= viewModel.averageSteps ? Color.customBlue : .customPink)
                .cornerRadius(10, style: .continuous)
            }
            RuleMark(y: .value("Average", viewModel.averageSteps))
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                .foregroundStyle(.customDarkBlue)
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.customBlue.opacity(0.1))
        }
        .frame(height: 200)
        .padding(.horizontal, 40)
    }

    
// MARK: Functions
    private func updateProgress() {
        viewModel.loadTodayStepCount()
        viewModel.loadStepCounts()
    }
}

#Preview {
    MainView()
}

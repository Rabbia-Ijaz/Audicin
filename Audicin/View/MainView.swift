//
//  ContentView.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 15/11/2024.
//

import SwiftUI
import Charts

struct MainView: View {
    
    let weeklySteps: [StepData] = [
        StepData(day: "Mon", steps: 3000),
        StepData(day: "Tue", steps: 5000),
        StepData(day: "Wed", steps: 7000),
        StepData(day: "Thu", steps: 4000),
        StepData(day: "Fri", steps: 8000),
        StepData(day: "Sat", steps: 6000),
        StepData(day: "Sun", steps: 9000)
    ]
    
    @StateObject private var viewModel = StepCountViewModel()
    
    var body: some View {
        ZStack{
            Color.customPurple.ignoresSafeArea()
            VStack(spacing: 10) {
                
                Text("Weekly Activity & Playlists")
                    .font(.system(size: 24, weight: .black))
                    .padding(.top,30)
                Spacer()
                VStack(spacing: 10) {
                    Image(systemName: "figure.walk")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(.white)
                    
                    Text("Step Count")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    Text("5000")
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(.white)
                }
                .padding(20)
                .cornerRadius(10)
                .background(Color.customBlue)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(20), radius: 15, x: 0,y: 0)
                
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("Open Playlist")
                            .font(.system(size: 20, weight: .black))
                            .foregroundStyle(Color.white)
                    }
                    .frame(height: 54)
                    .padding(.horizontal,20)
                    .background(Color.customBlue)
                    .cornerRadius(27)
                })
                .padding(.top,30)
                
                
                Spacer()
                
                //                chartView
//                VStack {
//                    if !viewModel.weeklyStepCounts.isEmpty {
//                        List(viewModel.weeklyStepCounts.sorted(by: { $0.key < $1.key }), id: \.key) { date, steps in
//                            VStack(alignment: .leading) {
//                                Text("\(date.formatted(.dateTime.month().day()))")
//                                    .font(.headline)
//                                Text("\(steps) steps")
//                                    .font(.subheadline)
//                            }
//                        }
//                    } else if let error = viewModel.error {
//                        Text("Error: \(error.localizedDescription)")
//                    } else {
//                        ProgressView("Loading step data...")
//                    }
//                }
//                .onAppear {
//                    viewModel.loadStepCounts()
//                }
                
                Spacer()
                
            }
        }
    }
    
    var chartView: some View {
        Chart {
            ForEach(weeklySteps) { data in
                BarMark(
                    x: .value("Day", data.day),
                    y: .value("Steps", data.steps)
                )
                .foregroundStyle(data.steps < 5000 ? .red : Color.customBlue)
                .cornerRadius(10, style: .continuous)
                
                
                
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.customBlue.opacity(0.3))
                .border(Color.customBlue)
        }
        .frame(height: 200)
        .padding(.horizontal,40)
    }
}

#Preview {
    MainView()
}

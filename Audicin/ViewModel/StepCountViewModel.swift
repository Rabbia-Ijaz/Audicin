//
//  StepCountViewModel.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 15/11/2024.
//

import Foundation
class StepCountViewModel: ObservableObject {
    @Published var weeklyStepCounts: [Date: Int] = [:]
    @Published var error: Error?

    private let manager = StepCountManager()

    func loadStepCounts() {
        manager.fetchStepCountsForPastWeek { [weak self] stepCounts, error in
            DispatchQueue.main.async {
                if let stepCounts = stepCounts {
                    self?.weeklyStepCounts = stepCounts
                } else {
                    self?.error = error
                }
            }
        }
    }
}

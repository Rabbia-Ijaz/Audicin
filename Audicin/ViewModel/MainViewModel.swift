import Foundation
import HealthKit

class MainViewModel: ObservableObject {
    @Published var weeklyStepCounts: [Date: Int] = [:]
    @Published var todayStepCount: Int = 0
    @Published var averageSteps: Int = 0
    @Published var progress: Double = 0.0
    @Published var error: Error?

    private let manager = StepCountManager()
    private let healthKitManager = HealthKitManager()
    
    func loadStepCounts() {
        healthKitManager.requestAuthorization { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.fetchStepData()
                } else {
                    self?.error = error ?? NSError(domain: "com.example.Audicin", code: 1, userInfo: [NSLocalizedDescriptionKey: "Authorization not granted"])
                }
            }
        }
    }
    
    private func fetchStepData() {
        manager.fetchStepCountsForPastWeek { [weak self] stepCounts, error in
            DispatchQueue.main.async {
                if let stepCounts = stepCounts {
                    self?.weeklyStepCounts = stepCounts
                    self?.averageSteps = Int(stepCounts.values.reduce(0, +) / stepCounts.count)
                    self?.progress = (self?.averageSteps ?? 0 > 0) ? CGFloat(self?.todayStepCount ?? 0) / CGFloat(self?.averageSteps ?? 0) : 0
                } else {
                    self?.error = error
                }
            }
        }
    }
    
    func loadTodayStepCount() {
        manager.fetchTodayStepCount { [weak self] stepCount, error in
            DispatchQueue.main.async {
                if let stepCount = stepCount {
                    self?.todayStepCount = stepCount
                } else {
                    self?.error = error
                }
            }
        }
    }
}

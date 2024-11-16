//
//  StepCountManager.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 16/11/2024.
//

import Foundation
import HealthKit

class StepCountManager {
    let healthStore = HKHealthStore()
    
    func fetchStepCountsForPastWeek(completion: @escaping ([Date: Int]?, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device."]))
            return
        }
        
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let calendar = Calendar.current
        let now = Date()
        
        // Adjust to start on the 9th (one day after 8th Nov)
        var startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        let endDate = now
        
        // Ensure the range starts at 9th November by adjusting startDate manually
        startDate = calendar.startOfDay(for: startDate)
        startDate = calendar.date(byAdding: .day, value: 1, to: startDate)! // 9th November
        
        // Create a predicate
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Create a statistics query
        let query = HKStatisticsCollectionQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: calendar.startOfDay(for: now),
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            var stepCounts: [Date: Int] = [:]
            
            // Normalize the start and end dates to remove the time component
            let startOfDay = calendar.startOfDay(for: startDate)
            let endOfDay = calendar.startOfDay(for: endDate)
            
            // Create an empty dictionary with zero steps for each day in the date range (stripped of time)
            var currentDate = startOfDay
            while currentDate <= endOfDay {
                stepCounts[currentDate] = 0
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            
            // Enumerate over the results and update the dictionary with actual step counts
            results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                    let date = calendar.startOfDay(for: statistics.startDate) // Normalize date to remove time
                    stepCounts[date] = stepCount
                }
            }
            
            // Complete with the updated step counts
            completion(stepCounts, nil)
        }
        
        healthStore.execute(query)
    }


    func fetchTodayStepCount(completion: @escaping (Int?, Error?) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, error in
            guard let statistics = statistics, let sum = statistics.sumQuantity() else {
                completion(nil, error)
                return
            }
            let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
            completion(stepCount, nil)
        }

        healthStore.execute(query)
    }
}

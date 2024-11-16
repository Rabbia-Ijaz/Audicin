//
//  HealthKitManager.swift
//  Audicin
//
//  Created by Rabbia Ijaz on 15/11/2024.
//

import Foundation
import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let typesToShare: Set<HKSampleType> = [] // No data to write for this task
        let typesToRead: Set = [stepCountType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
}

import HealthKit

class StepCountManager {
    let healthStore = HKHealthStore()
    
    func fetchStepCountsForPastWeek(completion: @escaping ([Date: Int]?, Error?) -> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // Define the date range (last 7 days)
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        let endDate = now
        
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
            
            results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let stepCount = Int(sum.doubleValue(for: HKUnit.count()))
                    let date = statistics.startDate
                    stepCounts[date] = stepCount
                }
            }
            
            completion(stepCounts, nil)
        }
        
        healthStore.execute(query)
    }
}

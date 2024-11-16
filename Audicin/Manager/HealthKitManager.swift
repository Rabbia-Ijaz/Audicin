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


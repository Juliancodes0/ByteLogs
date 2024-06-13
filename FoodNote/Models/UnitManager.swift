//
//  UnitManager.swift
//  FoodNote
//
//  Created by Julian 沙 on 6/12/24.
//

import Foundation

class UnitManager {
    var unitPreference: WeightUnitOfMeasurement = .lbs
    var energyPreference: EnergyUnitOfMeasurement = .cal
    
    static let shared = UnitManager()
    
    
    func saveUserUnitPreference (preference: WeightUnitOfMeasurement) {
        guard let encoded = try? JSONEncoder().encode(preference) else {
            return
        }
        self.unitPreference = preference
        UserDefaults.standard.setValue(encoded, forKey: "unitPreference")
    }
    
    func getUnitPreference () -> WeightUnitOfMeasurement {
        if let data = UserDefaults.standard.data(forKey: "unitPreference") {
            guard let decoded = try? JSONDecoder().decode(WeightUnitOfMeasurement.self, from: data) else {
                return .lbs
            }
            self.unitPreference = decoded
        }
        return self.unitPreference
    }
    
    func saveUserEnergyPreference (preference: EnergyUnitOfMeasurement) {
        guard let encoded = try? JSONEncoder().encode(preference) else {
            return
        }
        UserDefaults.standard.setValue(encoded, forKey: "energyPreference")
    }
    
    func getUserEnergyPreference () -> EnergyUnitOfMeasurement {
        if let data = UserDefaults.standard.data(forKey: "energyPreference") {
            guard let decoded = try? JSONDecoder().decode(EnergyUnitOfMeasurement.self, from: data) else {
                return .cal
            }
            
            self.energyPreference = decoded
        }
        return self.energyPreference
    }
}

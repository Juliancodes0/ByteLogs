//
//  User.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import Foundation


//Not yet used
enum WeightUnitOfMeasurement : Codable {
    case lbs
    case kg
    case stone
}

//Not yet used
enum EnergyUnitOfMeasurement: Codable {
    case cal
    case kcal
}

class User {
        
    var userLoadedApp: Bool = false
    var calorieGoal: Int = 0
    var unitPreference: WeightUnitOfMeasurement = .lbs
    var energyPreference: EnergyUnitOfMeasurement = .cal
    
    func saveUserLoadedApp () {
        UserDefaults.standard.setValue(true, forKey: "userLoadedApp")
    }
    
    func userDidLoadApp () -> Bool {
        self.userLoadedApp = true
        return UserDefaults.standard.bool(forKey: "userLoadedApp")
    }
    
    func saveCalorieGoal (goal: Int) {
        UserDefaults.standard.setValue(goal, forKey: "goalCalories")
    }
    
    func getUserCalorieGoal () -> Int {
        return UserDefaults.standard.integer(forKey: "goalCalories")
    }
    
    func saveUserGoalWeight(weight: Double) {
        UserDefaults.standard.setValue(weight, forKey: "userGoalWeight")
    }
    
    func getUserGoalWeight () -> Double {
        return UserDefaults.standard.double(forKey: "userGoalWeight")
    }
    
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

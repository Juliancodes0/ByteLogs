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

class UserBasicsManager {
        
    var userLoadedApp: Bool = false
    var calorieGoal: Int = 0
    
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
}

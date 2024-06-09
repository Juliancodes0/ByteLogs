//
//  MealModel.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import Foundation
import CoreData

struct MealModel: Identifiable, FoodItemProtocol {
    let meal: Meal
    var id: NSManagedObjectID {
        return meal.objectID
    }
    var title: String {
        return meal.title ?? ""
    }
    var date: Date? {
        return meal.date
    }
    var calories: Int16 {
        return meal.calories
    }
    var category: Int16 {
        return meal.category //1 breakfast, 2 lunch, 3 dinner, 4 snack
    }
    var isMeal: Bool {
        return true
    }
}

//
//  FoodModel.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import Foundation
import CoreData

struct FoodModel : Identifiable, FoodItemProtocol {
    let food: Food
    var id: NSManagedObjectID {
        return food.objectID
    }
    var title: String {
        return food.title ?? ""
    }
    var date: Date? {
        return food.date
    }
    var calories: Int16 {
        return food.calories
    }
    var category: Int16 {
        return food.category //1 breakfast, 2 lunch, 3 dinner, 4 snack, 5 used for foods without category (added to a meal as a duplicate - are attached to specific meals)
    }
    var isMeal: Bool {
        return false
    }
//    var meals: NSSet? {
//        return food.meals
//    } //IF NIL, do something...
}

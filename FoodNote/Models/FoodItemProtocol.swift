//
//  FoodItemProtocol.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import Foundation
import CoreData

protocol FoodItemProtocol {
    var id: NSManagedObjectID {get}
    var calories: Int16 {get}
    var category: Int16 {get}
    var title: String {get}
    var date: Date? {get}
    
    var isMeal: Bool {get}
}

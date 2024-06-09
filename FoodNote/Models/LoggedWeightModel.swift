//
//  LoggedWeightModel.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import Foundation
import CoreData

struct LoggedWeightModel: Identifiable {
    let loggedWeight: LoggedWeight
    
    var id: NSManagedObjectID {
        return loggedWeight.objectID
    }

    var dateLogged: Date {
        return loggedWeight.dateLogged ?? Date()
    }
    
    var weight: Double {
        return loggedWeight.weight
    }
}

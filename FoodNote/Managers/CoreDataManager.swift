//
//  CoreDataManager.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer

    private init () {
        persistentContainer = NSPersistentContainer(name: "FoodDataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                print ("Error in section 1")
                fatalError("Failed to init CoreData \(error.localizedDescription)")
            }
        }
                
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(directories[0])
    }
    
    func save () {
        do {
            try self.persistentContainer.viewContext.save()
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func getFoodById(_ id: NSManagedObjectID) -> Food? {
        do {
            return try self.persistentContainer.viewContext.existingObject(with: id) as? Food
        } catch {
            return nil
        }
    }
    
    func getMealById(_ id: NSManagedObjectID) -> Meal? {
        do {
            return try self.persistentContainer.viewContext.existingObject(with: id) as? Meal
        } catch {
            return nil
        }
    }

    
//    func deleteAllTasks () {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskItem")
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try persistentContainer.viewContext.execute(batchDeleteRequest)
//            save()
//        } catch {
//            persistentContainer.viewContext.rollback()
//        }
//    }
        
    func getAllMeals () -> [Meal] {
        let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getAllLoggedWeights () -> [LoggedWeight] {
        let fetchRequest: NSFetchRequest<LoggedWeight> = LoggedWeight.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteLoggedWeight(_ loggedWeight: LoggedWeight) {
        persistentContainer.viewContext.delete(loggedWeight)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    
    func deleteAllNotes () {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(batchRequest)
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func deleteFood(_ food: Food) {
        persistentContainer.viewContext.delete(food)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
        
    func deleteMeal(_ meal: Meal) {
        persistentContainer.viewContext.delete(meal)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
    
    func getAllFoods () -> [Food] {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getAllNoteEntities () -> [NoteEntity] {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteNote(_ note: NoteEntity) {
        persistentContainer.viewContext.delete(note)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
        }
    }
}

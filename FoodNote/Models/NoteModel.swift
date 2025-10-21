//
//  NoteModel.swift
//  FoodNote
//
//  Created by Julian on 10/9/25.
//

import Foundation
import CoreData

protocol NoteMock {
    var noteEntity: NoteEntity {get}
    var date: Date {get}
    var notes: String {get}
}



struct NoteModel : NoteMock {
    let noteEntity: NoteEntity
    var id: NSManagedObjectID {
        return noteEntity.objectID
    }
    var date: Date {
        return noteEntity.date ?? Date()
    }
    
    var notes: String {
        return noteEntity.notes ?? ""
    }
}

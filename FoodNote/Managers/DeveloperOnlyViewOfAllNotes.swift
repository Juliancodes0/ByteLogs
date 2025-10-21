//
//  DeveloperOnlyViewOfAllNotes.swift
//  FoodNote
//
//  Created by Julian on 10/21/25.
//

//import SwiftUI
//
//class DevViewModel: ObservableObject {
//    @Published var notes: [NoteModel] = []
//    
//    func getNotes () {
//        let allNotes = CoreDataManager.shared.getAllNoteEntities()
//        DispatchQueue.main.async {
//            self.notes = allNotes.map(NoteModel.init)
//        }
//    }
//    
//    func deleteAllNotes () {
//        CoreDataManager.shared.deleteAllNotes()
//    }
//}
//
//struct DeveloperOnlyViewOfAllNotes: View {
//    @StateObject private var viewModel = DevViewModel()
//    var body: some View {
//        VStack {
//            List(viewModel.notes, id: \.id) { note in
//                Text(note.notes)
//            }
//        }.listStyle(.plain)
//            .onAppear() {
//                viewModel.getNotes()
//            }
//    }
//}
//
//#Preview {
//    DeveloperOnlyViewOfAllNotes()
//}

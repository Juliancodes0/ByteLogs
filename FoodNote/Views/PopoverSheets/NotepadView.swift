//
//  NotepadView.swift
//  FoodNote
//
//  Created by Julian on 10/9/25.
//

import SwiftUI

class NotepadViewModel: ObservableObject {
    
    func save(note: String, date: Date, onComplete: () -> ()) {
        guard !note.isEmpty else {
            onComplete()
            return
        }
        let manager = CoreDataManager.shared
        let newNote = NoteEntity(context: manager.persistentContainer.viewContext)
        newNote.date = date
        newNote.notes = note
        manager.save()
        onComplete()
    }
}

import SwiftUI

struct NotepadView: View {
    @State var text: String = ""
    private var saveText: String {
        switch text.isEmpty {
        case true:
            return "DONE"
        case false:
            return "SAVE"
        }
    }
    let dateOfNote: Date
    @StateObject var viewModel: NotepadViewModel = NotepadViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            LinearGradient.glassGradientColors
                .ignoresSafeArea()

            VStack {
                ZStack {
                    Text(dateOfNote.formatted(date: .abbreviated, time: .omitted))
                        .bold()
                    
                    HStack {
                        Spacer()
                        Button(saveText) {
                            viewModel.save(note: self.text, date: dateOfNote, onComplete: {
                                self.dismiss()
                            })
                        }
                        .bold()
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer()

                Divider()

                TextEditor(text: $text)
                    .tint(.red)
                    .padding()
            }
        }
    }
}

#Preview {
    NotepadView(dateOfNote: Date())
}

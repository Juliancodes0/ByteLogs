//
//  NotepadView.swift
//  FoodNote
//
//  Created by Julian on 10/9/25.
//

import SwiftUI

class NotepadViewModel: ObservableObject {
    @Published var note: NoteModel? = nil

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
    
    func findNoteByDate (date: Date) {
        let allNotes = CoreDataManager.shared.getAllNoteEntities()
        DispatchQueue.main.async {
            self.note = allNotes.map(NoteModel.init).first(where: {$0.date.isSameDay(as: date)})
        }
    }
    
    func overwriteNoteAndSave (note: String, date: Date, onComplete: () -> ()) {
        if let editing = self.note {
            CoreDataManager.shared.deleteNote(editing.noteEntity)
        }
        self.save(note: note, date: date, onComplete: onComplete)
    }
}


struct NotepadView: View {
    @State private var text: String = ""
    @State private var animateGradient = false
    let dateOfNote: Date
    @StateObject private var viewModel = NotepadViewModel()
    @Environment(\.dismiss) private var dismiss

    private var saveText: String {
        text.isEmpty ? "DONE" : "SAVE"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.7),
                    Color.blue.opacity(0.6),
                    Color.cyan.opacity(0.5),
                    Color.pink.opacity(0.5)
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .blur(radius: 40)
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }

            VStack(spacing: 20) {
                HStack {
                    Text(dateOfNote.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        viewModel.overwriteNoteAndSave(note: text, date: dateOfNote) {
                            dismiss()
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        Text(saveText)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    colors: text.isEmpty
                                        ? [Color.green.opacity(0.8), Color.teal.opacity(0.7)]
                                        : [Color.blue.opacity(0.8), Color.purple.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                            .scaleEffect(text.isEmpty ? 0.95 : 1.05)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: text)
                    }
                    .padding(.trailing)
                }
                .padding(.top, 12)
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Start typing your thoughts...")
                            .foregroundColor(.white.opacity(0.4))
                            .padding(EdgeInsets(top: 14, leading: 8, bottom: 0, trailing: 0))
                            .transition(.opacity)
                    }

                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        )
                        .foregroundColor(.white)
                        .font(.system(.body, design: .rounded))
                        .tint(.pink)
                        .frame(maxHeight: .infinity)
                }
                .padding(.horizontal)
                .animation(.easeInOut, value: text)
            }
            .padding(.bottom)
        }
        .onAppear(perform: {
            viewModel.findNoteByDate(date: self.dateOfNote)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if let edited = viewModel.note {
                    self.text = edited.notes
                }
            })
        })
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NotepadView(dateOfNote: Date())
}

//
//  ViewDaysNotes.swift
//  FoodNote
//
//  Created by Julian on 10/20/25.
//

import SwiftUI

class ViewDaysNotesViewModel: ObservableObject {
    @Published var note: NoteModel? = nil
        
    func getNoteForDate(_ date: Date) {
        let allNotes = CoreDataManager.shared.getAllNoteEntities()
        DispatchQueue.main.async {
            self.note = allNotes.map(NoteModel.init).first(where: {$0.date.isSameDay(as: date)})
        }
    }
    
    
    func deleteNote (_ note: NoteEntity) {
        CoreDataManager.shared.deleteNote(note)
    }
}


struct ViewDaysNotes: View {
    let date: Date
    @StateObject private var viewModel = ViewDaysNotesViewModel()
    @State private var animateGradient = false
    @State private var goToNoteEditor: Bool = false
    @Environment(\.dismiss) private var dismiss
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
                viewModel.getNoteForDate(date)
            }
            
            VStack(spacing: 16) {
                dateTopBar
                
                if viewModel.note == nil {
                    VStack(spacing: 8) {
                        Image(systemName: "note.text")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.4))
                        Text("No notes yet for this day.")
                            .foregroundColor(.white.opacity(0.5))
                            .font(.headline)
                    }
                    .padding(.top, 80)
                    .transition(.opacity)
                } else {
                    self.note
                    .onTapGesture {
                        goToNoteEditor = true
                    }
                }
                
                Spacer()
                
                //MARK: ADD NOTE WHEN NIL
                if viewModel.note == nil {
                    HStack {
                        Spacer()
                        Button {
                            goToNoteEditor = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }
                        
                    }.padding()
                }
                //MARK: END OF ADD NOTE WHEN NIL
            }
        }
        .fullScreenCover(isPresented: $goToNoteEditor, onDismiss: {
            viewModel.getNoteForDate(self.date)
        }, content: {
            NotepadView(dateOfNote: self.date)
        })
        .preferredColorScheme(.dark)
    }
}

extension ViewDaysNotes {
    var dateTopBar: some View {
        HStack {
            Spacer()
            
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.title2.bold())
                .foregroundColor(.white.opacity(0.9))
                .padding(.top)
                .shadow(radius: 10)
            
            Spacer()
            
            Button {
                self.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
}

extension ViewDaysNotes {
    var note: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.note?.notes ?? "")
                .font(.system(.body, design: .rounded))
                .foregroundColor(.white)
                .lineSpacing(6)
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            if let noteDate = viewModel.note?.date {
                Text(noteDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
        .transition(.opacity.combined(with: .scale))

    }
}



#Preview {
    ViewDaysNotes(date: Date())
}

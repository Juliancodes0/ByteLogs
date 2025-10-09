//
//  NotepadView.swift
//  FoodNote
//
//  Created by Julian on 10/9/25.
//

import SwiftUI

class NotepadViewModel: ObservableObject {
    @Published var text: String = ""
    
    func save(note: String) {
        
    }
}

import SwiftUI

struct NotepadView: View {
    let dateOfNote: Date
    @StateObject var viewModel: NotepadViewModel = NotepadViewModel()
    
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
                        Button("SAVE") {
                        }
                        .bold()
                        .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer()

                Divider()

                TextEditor(text: $viewModel.text)
                    .tint(.red)
                    .padding()
            }
        }
    }
}






#Preview {
    NotepadView(dateOfNote: Date())
}

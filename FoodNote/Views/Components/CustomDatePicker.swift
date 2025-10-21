//
//  CustomDatePicker.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var date: Date
    @Binding var buttonShouldBeActive: Bool
    @Binding var opacityIsMuted: Bool
    let padding: CGFloat = 15
    var completionLeftToggle: ( () -> ())?
    var completionRightToggle: ( () -> ())?
    @State var convertToDateToggleView: Bool = false
    @State var viewNotes: Bool = false
    var reloadDelegate: DataReloadDelegate?
    var body: some View {
        if !convertToDateToggleView {
            mainToggle
        } else {
            VStack {
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .onTapGesture {
                    withAnimation {
                        self.convertToDateToggleView = false
                        self.opacityIsMuted = false
                        self.reloadDelegate?.reloadData()
                    }
                }
                .onChange(of: date) { oldValue, newValue in
                    withAnimation {
                        self.convertToDateToggleView = false
                        self.opacityIsMuted = false
                        self.reloadDelegate?.reloadData()
                    }
                }
            }
        }
    }
}

extension CustomDatePicker {
    var mainToggle: some View {
        ZStack {
            HStack {
                Button(action: {
                    let date = Calendar.current.date(byAdding: .day, value: -1, to: self.date)
                    self.date = date ?? Date()
                    completionLeftToggle?()
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(Color.indigo)
                        .shadow(radius: 3)
                }).padding(.trailing, self.padding)
                    .disabled(!buttonShouldBeActive)
                
                Button(action: {
                    withAnimation {
                        convertToDateToggleView = true
                    }
                    withAnimation {
                        self.opacityIsMuted = true
                    }
                }, label: {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .padding(4)
                }).disabled(!buttonShouldBeActive)
                
                
                    .background() {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(Color.lavenderColor)
                    }
                
                Button(action: {
                    let date = Calendar.current.date(byAdding: .day, value: 1, to: self.date)
                    self.date = date ?? Date()
                    completionRightToggle?()
                }, label: {
                    Image(systemName: "arrow.right")
                        .foregroundStyle(Color.indigo)
                        .shadow(radius: 3)
                }).padding(.leading, self.padding)
                
            }
                .foregroundStyle(Color.black).opacity(0.8)
                .bold()
                .disabled(!buttonShouldBeActive)
            
            HStack {
                Spacer()
                Button {
                    viewNotes = true
                } label: {
                    Image(systemName: "heart.text.clipboard.fill")
                        .resizable()
                        .frame(width: 21, height: 25)
                        .foregroundStyle(LinearGradient(colors: [Color.red, Color.indigo], startPoint: .topTrailing, endPoint: .bottomLeading))
                }.fullScreenCover(isPresented: $viewNotes) {
                } content: {
                    ViewDaysNotes(date: self.date)
                }


            }.padding()
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    CustomDatePicker(date: .constant(Date()), buttonShouldBeActive: .constant(true), opacityIsMuted: .constant(false))
}

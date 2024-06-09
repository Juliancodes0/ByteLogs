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
                    }
                }
                .onChange(of: date) { oldValue, newValue in
                    withAnimation {
                        self.convertToDateToggleView = false
                        self.opacityIsMuted = false
                    }
                }
            }
        }
    }
}

extension CustomDatePicker {
    var mainToggle: some View {
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
        }.preferredColorScheme(.light)
        .foregroundStyle(Color.black).opacity(0.8)
            .bold()
            .disabled(!buttonShouldBeActive)

    }
}

#Preview {
    CustomDatePicker(date: .constant(Date()), buttonShouldBeActive: .constant(true), opacityIsMuted: .constant(false))
}

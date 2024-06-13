//
//  TopRowView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

struct TopRowView : View {
    let user: UserBasicsManager
    @Binding var date: Date
    @Binding var calories: Int16
    @Binding var buttonShouldBeActive: Bool
    @Binding var opacityIsMuted: Bool
    var completionLeftToggle: ( () -> ())?
    var completionRightToggle: ( () -> ())?
    var reloadDelegate: DataReloadDelegate?
    var body: some View {
        VStack {
            VStack {
            Text("ByteLogs")
                .font(.caption)
                .bold()
                .foregroundStyle(Color.gray)
            Divider()
            Text("Goal: \(user.getUserCalorieGoal())") //consumed that day - run some calculation
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color.gray)
            
            Text("Total: \(calories)")
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color.gray)
            
            Text("Remaining: \(Int16(user.getUserCalorieGoal()) - self.calories)") //goal minus consumed
                .font(.subheadline)
                .bold()
                .foregroundStyle(Color.gray)
            Divider()
        }.opacity(self.opacityIsMuted ? 0 : 1)
            CustomDatePicker(date: $date, buttonShouldBeActive: $buttonShouldBeActive, opacityIsMuted: $opacityIsMuted, completionLeftToggle: completionLeftToggle, completionRightToggle: completionRightToggle, reloadDelegate: reloadDelegate)
                .padding(.top, 1)
        }.preferredColorScheme(.light)
    }
}

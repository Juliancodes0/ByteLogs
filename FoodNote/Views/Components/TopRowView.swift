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
    @State var goToCalorieAdjustmentView: Bool = false
    var completionLeftToggle: ( () -> ())?
    var completionRightToggle: ( () -> ())?
    var reloadDelegate: DataReloadDelegate?
    var body: some View {
        VStack {
            VStack {
            Text("ByteLogs")
                .font(.caption)
                .bold()
                .foregroundStyle(Color.black)
                .stroke(color: .cyan.opacity(0.2), width: 0.5)
            Divider()
                VStack {
                    Text("Goal: \(user.getUserCalorieGoal())") //consumed that day - run some calculation
                        .font(.subheadline)
                        .bold()
                    Text("Total: \(calories)")
                        .font(.subheadline)
                        .bold()
                    Text("Remaining: \(Int16(user.getUserCalorieGoal()) - self.calories)") //goal minus consumed
                        .font(.subheadline)
                        .bold()
                }.onTapGesture {
                    goToCalorieAdjustmentView = true
                }
                .foregroundStyle(
                    LinearGradient(colors: [.black, .indigo], startPoint: .leading, endPoint: .trailing)
                )
                .stroke(color: Color.glass, width: 0.3)
            Divider()
        }.opacity(self.opacityIsMuted ? 0 : 1)
            CustomDatePicker(date: $date, buttonShouldBeActive: $buttonShouldBeActive, opacityIsMuted: $opacityIsMuted, completionLeftToggle: completionLeftToggle, completionRightToggle: completionRightToggle, reloadDelegate: reloadDelegate)
                .padding(.top, 1)
        }.preferredColorScheme(.light)
            .fullScreenCover(isPresented: $goToCalorieAdjustmentView) {
                reloadDelegate?.reloadData()
            } content: {
                CaloriesView(user: user, seguedFromProgressView: true, calorieRecommendationAmount: user.calorieGoal)
            }
    }
}

#Preview {
    @State var date = Date()
    @State var calories: Int16 = 1400
    @State var buttonShouldBeActive = true
    @State var opacityIsMuted = false

    return TopRowView(
        user: UserBasicsManager(), // ensure this works
        date: $date,
        calories: $calories,
        buttonShouldBeActive: $buttonShouldBeActive,
        opacityIsMuted: $opacityIsMuted,
        completionLeftToggle: {},
        completionRightToggle: {},
        reloadDelegate: nil
    )
}

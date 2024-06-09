//
//  MealBoxComponent2.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

///MEAL BOX WITH VERTICALLY ALIGNED FOODS OVERLAYING A RECTANGLE
struct MealBoxComponent2: View {
    @Binding var foods: [FoodModel]
    var body: some View {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width / 1.2, height: 100)
                .cornerRadius(31.0)
                .shadow(radius: 10)
                .overlay {
                    ScrollView {
                    VStack {
                            ForEach(foods) { food in
                                Text(food.title)
                                    .foregroundStyle(Color.white)
                            }
                        }.padding()
                    }
                }
    }
}

//
//  MealBox.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

//Was used in CreateMealView - No longer being used. Keep component
struct MealBox: View {
    @Binding var addedToArray: [FoodModel]
    
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width / 1.2, height: 120)
            .cornerRadius(31.0)
            .shadow(radius: 10)
            .foregroundStyle(Color.white)
            .overlay {
                VStack {
                    Text("Foods Items:")
                        .foregroundStyle(Color.black.opacity(0.8))
                        .fontWeight(.semibold)
                        .padding(.top, 5)
                    Divider()
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(addedToArray) { food in
                                HStack {
                                    Text(food.title)
                                        .fontWeight(.semibold)
                                    //
                                    
                                }
                                //
                                
                            }
                        }
                        .padding()
                    }
                }
            }.hideScrollBar()
            .foregroundStyle(Color.black)

    }
}

//
//  FoodDetailedRowView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

struct FoodDetailedRowView: View {
    let food: FoodModel
    let foodCount: Int16
    
    var foodImageAssets: [String] = [
    "leaf.fill",
    "carrot",
    "fork.knife"
    ]
    
    private var energyUnitString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return food.calories == 1 ? "calorie" : "calories"
        case .kilojoules:
            return "kJ"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: foodImageAssets.randomElement() ?? "leaf.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.title)
                    .font(.headline)
                    .foregroundColor(Color.white)
                
                Text("\(foodCount) \(foodCount == 1 ? "Serving" : "Servings")")
                    .foregroundColor(Color.white.opacity(0.8))
                
                Text("\(food.calories) \(energyUnitString)")
                    .foregroundColor(Color.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.blue.opacity(0.3)]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .padding([.horizontal, .top])
    }
}


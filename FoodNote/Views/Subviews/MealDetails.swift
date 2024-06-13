//
//  MealDetails.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

class MealDetailsViewModel : ObservableObject {
    @Published var mealFoods: [FoodModel] = []
    
    func getFoodsForMeal(meal: Meal) {
        guard let foodsSet = meal.foods as? Set<Food> else {
            return
        }
        let foods: [FoodModel] = foodsSet.map { food in
            FoodModel(food: food)
        }
        
        self.mealFoods = foods.unique(by: {$0.title == $1.title && $0.calories == $1.calories})
        
    }
    
    func getCountOfFood(meal: Meal, food: Food) -> Int16 {
        var count: Int16 = 0
        
        let foods = meal.foods as? Set<Food> ?? []
        for i in foods {
            if i.title == food.title && i.calories == food.calories && i.date == nil {
                count += 1
            }
        }
        return count
    }
}

struct MealDetails: View {
    @StateObject var viewModel: MealDetailsViewModel = MealDetailsViewModel()
    let meal: MealModel
    
    var unitString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return "calories"
        case .kilojoules:
            return "kJ"
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.2, blue: 0.4).opacity(0.6), // Darker pink
                    Color(red: 0.9, green: 0.6, blue: 0.4).opacity(0.6), // Darker peach
                    Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.6)  // Darker blue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all)
            VStack {
                Text(meal.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .foregroundColor(.white)
                
                Text("Total \(unitString): \(meal.calories)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                if viewModel.mealFoods.count > 0 {
                    ScrollView(.vertical) {
                        ForEach(viewModel.mealFoods, id: \.id) { food in
                            FoodDetailedRowView(food: food, foodCount: viewModel.getCountOfFood(meal: self.meal.meal, food: food.food))
                                .padding(.horizontal)
                                .padding(.bottom, 8)  // Adding some spacing between rows
                        }
                    }
                    .padding(.top, 10)
                } else {
                    Spacer()
                    Text("No foods added to this meal")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
        }.preferredColorScheme(.light)
        .onAppear {
            viewModel.getFoodsForMeal(meal: meal.meal)
        }
    }
}



///Deprecated
struct MealDetailsDeprecated: View {
    @StateObject var viewModel: MealDetailsViewModel = MealDetailsViewModel()
    let meal: MealModel
    var body: some View {
        VStack {
            Text(meal.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            Text("Total calories: \(meal.calories)")
            Spacer()
            
                if viewModel.mealFoods.count > 0 {
                    ScrollView(.vertical) {

                    ForEach(viewModel.mealFoods, id: \.id) { food in
                        FoodDetailedRowView(food: food, foodCount: 0)
                    }
                }
                } else {
                    Spacer()
                    Text("No foods added to this meal")
                        .fontWeight(.semibold)
                    Spacer()
                    Spacer()
                }
            Spacer()
        }
        .onAppear {
            viewModel.getFoodsForMeal(meal: meal.meal)
        }
    }

    func getCountForFood(_ food: FoodModel) -> Int16 {
        var count: Int16 = 0
        
        // Convert NSSet to Array to allow duplicate counting
        if let foodSet = self.meal.meal.foods as? Set<Food> {
            let foodArray = Array(foodSet)
            
            // Print the total number of foods
            print("Total foods in the set: \(foodArray.count)")
            
            for i in foodArray {
                print("Checking food: \(i.title ?? "unknown") with calories: \(i.calories)")
                if i.title == food.food.title && i.calories == food.food.calories {
                    count += 1
                }
            }
        } else {
            print("Failed to cast foods to Set<Food>")
        }
        
        print("Count for food \(food.food.title ?? "unknown"): \(count)")
        return count
    }

    
    func getCountForFoodFunction2( _ food: FoodModel) -> Int16 {
        var count: Int16 = 0
        
        if let foodSet = self.meal.meal.foods as? Set<Food> {
            print("Count  \(foodSet.count)")
            for i in foodSet {
                if i.title == food.food.title && i.calories == food.food.calories {
                    count += 1
                }
            }
//            return Int16(foodSet.count) TEST
            /*
             Issue: This is returning 2 - when should be 8. It think there are only 2 foods total in the set, but there are actually 8. The means that duplicates are not working - however, would seem that the create meal view is working fine
             */
        }
        return 0
    }
    
}

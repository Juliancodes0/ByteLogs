//
//  FoodRow.swift
//  FoodNote
//
//  Created by Julian 沙 on 6/2/24.
//

import SwiftUI

struct FoodRow: View {
    let food: FoodItemProtocol
    var callback: ( () -> ()?)?
    let date: Date
    @State var showLineThrough: Bool = false
    @State var openMealDetails: Bool = false
    @State var editFood: Bool = false
    @State var editMeal: Bool = false
    @Environment(\.dismiss) var dismiss
    
    func stringForCalories() -> String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return food.calories == 1 ? " calorie" : "calories"
        case .kilojoules:
            return " kJ"
        }
    }
    
    var energyUnitPreferenceString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return "calories"
        case .kilojoules:
           return "kJ"
        }
    }
    
    var body: some View {
        HStack {
            Text(food.title)
                .font(.custom("Action_Man", size: 20))
                .strikethrough(showLineThrough)
            Spacer()
            Text("\(food.calories) \(stringForCalories())")
                .strikethrough(showLineThrough)
            if food.isMeal {
                Button(action: {
                    self.openMealDetails = true
                }, label: {
                    Image(systemName: "fork.knife.circle.fill")
                        .strikethrough(showLineThrough)
                })
            }
        }.foregroundStyle(Color.black)
        .preferredColorScheme(.light)
        .listRowBackground(
            ZStack {
                if !food.isMeal {
                    Color.clear
                } else {
                    Color.highligterPink.opacity(1)
                    }
            }.cornerRadius(5)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            
            Button(action: {
                withAnimation(.linear(duration: 0.01)) {
                    showLineThrough = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.77) {
                    deleteFoodItem(item: food)
                    callback?()
                }
            }, label: {
                Text("REMOVE")
                    .bold()
            })
            
            if !self.food.isMeal {
                Button(action: {
                    self.editFood = true
                }, label: {
                    Image(systemName: "pencil")
                }).tint(Color.yellow)
            }
            
            if self.food.isMeal {
                Button(action: {
                    self.editMeal = true
                }, label: {
                    Image(systemName: "pencil")
                }).tint(Color.yellow)
            }
        }
        .sheet(isPresented: $openMealDetails, onDismiss: {}, content: {
            MealDetails(meal: food as! MealModel)
        })
        
        .sheet(isPresented: $editFood, onDismiss: {
            callback?()
        }, content: {
            AddFoodSheet(dateForFood: self.date, foodEditing: self.food as? FoodModel)
        })
        .sheet(isPresented: $editMeal, onDismiss: {
            callback?()
        }, content: {
            CreateMealView(mealEditing: self.food as? MealModel)
        })
        .preferredColorScheme(.light)
    }

    private func deleteFoodItem(item: FoodItemProtocol) {
        switch item is FoodModel {
        case true:
            guard let foodItem = CoreDataManager.shared.getFoodById(item.id) else {return}
            CoreDataManager.shared.deleteFood(foodItem)
        case false:
            guard let mealItem = CoreDataManager.shared.getMealById(item.id) else {
                return
                }
            CoreDataManager.shared.deleteMeal(mealItem)
            CoreDataManager.shared.save()
            callback?()
        }
    }
}

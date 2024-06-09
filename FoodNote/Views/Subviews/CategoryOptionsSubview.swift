//
//  CategoryOptionsSubview.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

struct CategoryOptionsSubview: View {
    let meal: MealModel
    @StateObject var viewModel: AllMealsViewModel
    let dateToAdd: Date
    var completion: (() -> () )?
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.2, blue: 0.4).opacity(0.6),                    Color(red: 0.9, green: 0.6, blue: 0.4).opacity(0.6),
                    Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all)
            
            VStack(spacing: 30) {
                
                Button(action: {
                    viewModel.saveMealToDay(meal: meal, date: dateToAdd, category: 1)
                    completion?()
                    dismiss.callAsFunction()
                }, label: {
                    Text("Breakfast ☕️")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                })
                
                Button(action: {
                    viewModel.saveMealToDay(meal: meal, date: dateToAdd, category: 2)
                    completion?()
                    dismiss.callAsFunction()
                }, label: {
                    Text("Lunch 🥗")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                })
                
                Button(action: {
                    viewModel.saveMealToDay(meal: meal, date: dateToAdd, category: 3)
                    completion?()
                    dismiss.callAsFunction()                }, label: {
                    Text("Dinner 🥦")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                })
                
                Button(action: {
                    viewModel.saveMealToDay(meal: meal, date: dateToAdd, category: 4)
                    completion?()
                    dismiss.callAsFunction()
                }, label: {
                    Text("Snack 🍉")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.black)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                })
            }
            .padding(.horizontal)
        }.preferredColorScheme(.light)
    }
}

struct CategoryOptionsSubview_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let meal = Meal(context: context)
        
        let mealModel = MealModel(meal: meal)
        
        let viewModel = AllMealsViewModel()
        
        let dateToAdd = Date()
        
        return CategoryOptionsSubview(meal: mealModel, viewModel: viewModel, dateToAdd: dateToAdd)
            .environment(\.managedObjectContext, context)
    }
}

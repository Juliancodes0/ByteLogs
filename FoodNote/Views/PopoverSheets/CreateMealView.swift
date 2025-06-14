//
//  CreateMealView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI
import CoreData


struct FoodItemCell: View {
    let food: FoodModel
    var callback: (() -> ())?
    @Binding var isInFoodRemoveMode: Bool
    @Binding var addedToArray: [FoodModel]
    
    private var energyUnitString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return food.calories == 1 ? "calorie" : "calories"
        case .kilojoules:
            return "kJ"
        }
    }
    
    var body: some View {
        HStack {
            if isInFoodRemoveMode {
                removeButton
            } else {
                addButton
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
    }
    
    private var addButton: some View {
        Button(action: {
            callback?()
        }) {
            HStack {
                Text("\(food.title) : \(food.calories) \(energyUnitString)")
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
                
                if countForFood(food) <= 0 {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(6)
                        .background(Circle().fill(Color.blue))
                } else {
                    ZStack {
                        Circle()
                        .frame(width: 30, height: 30)
                            .foregroundStyle(Color.blue)
                            .opacity(0.8)
                        Text("\(countForFood(food))")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                   
                    }
            }
            .padding(8)
        }
    }

    private var removeButton: some View {
        Button(action: {
            callback?()
        }) {
            HStack {
                Text("\(food.title) : \(food.calories) \(energyUnitString)")
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 30, height: 30)
                    Text("\(countForFood(food))")
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
            }
            .padding(8)
        }
    }
    
    private func countForFood(_ food: FoodModel) -> Int {
        return addedToArray.filter { $0.id == food.id }.count
    }
}

class CreateMealViewModel : ObservableObject {
    @Published var foods: [FoodModel] = []
    @Published var addedToArray: [FoodModel] = []
    
    func getAllFoods () {
        DispatchQueue.main.async {
            self.foods = CoreDataManager.shared.getAllFoods().map(FoodModel.init)
        }
    }
}


struct CreateMealView: View {
    @State var title: String = ""
    @State var calories: String = ""
    @StateObject var viewModel: CreateMealViewModel = CreateMealViewModel()
    @State var isInRemoveFoodMode: Bool = false
    @State var searchBarText: String = ""
    @Environment(\.dismiss) var dismiss
    @FocusState var isFocused: FocusField?
    let mealEditing: MealModel?
    var dismissOpacity: Double = 1
    
    private var energyUnitString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return "Calories"
        case .kilojoules:
            return "kJ"
        }
    }
    
    var filteredFoodsResults: [FoodModel] {
        guard !searchBarText.isEmpty else {
            return viewModel.foods
        }
        return viewModel.foods.filter { result in
            result.title.lowercased().contains(searchBarText.lowercased())
        }
    }
    
    enum FocusField: Hashable {
        case title
        case calories
        case search
    }
    
    var body: some View {
        ZStack {
            LinearGradient.glassGradientColors.ignoresSafeArea()
            VStack(spacing: 30) {
                DismissButton(action: {
                    self.dismiss.callAsFunction()
                }, buttonOpacity: self.dismissOpacity)
                
                Text(self.mealEditing == nil ? "Create a meal" : "Edit meal")
                    .bold()
                    .padding(.top, 30)
                ScrollView() {
                    TextField("Meal title", text: $title)
                        .focused($isFocused, equals: .title)
                        .padding()
                        .frame(width: 180, height: 40)
                        .background() {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color.white)
                                .shadow(radius: 3)
                        }.padding()
                    TextField("\(energyUnitString)", text: $calories)
                        .padding()
                        .focused($isFocused, equals: .calories)
                        .keyboardType(.numberPad)
                        .frame(width: 180, height: 40)
                        .background() {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color.white)
                                .shadow(radius: 3)
                        }.padding()
                    Divider()
                        .padding(.bottom)
                    
                    VStack(spacing: 40) {
                        if viewModel.foods.count > 0 {
                            Text("Add foods to your meal?")
                            
                            TextField("Search foods...", text: $searchBarText)
                                .textFieldStyle(.roundedBorder)
                                .padding()
                                .focused($isFocused, equals: .search)
                        }
                    }
                    
                    if shouldShowModeToggle() {
                        Button(action: {
                            self.isInRemoveFoodMode.toggle()
                        }, label: {
                            switch self.isInRemoveFoodMode {
                            case true:
                                Image(systemName: "arrow.left")
                            case false:
                                Text("Remove foods")
                                    .foregroundStyle(Color.red)
                            }
                        }).padding()
                    }
                    
                    VStack(spacing: 50) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                let nonDuplicateFoodItems = self.filteredFoodsResults
                                    .sorted(by: { $0.date ?? Date() > $1.date ?? Date() }) // Sort by date in descending order
                                    .reduce(into: [FoodModel]()) { result, foodItem in
                                        if !result.contains(where: { $0.title == foodItem.title && $0.calories == foodItem.calories }) {
                                            /* If there is no item in the result with the same title and calorie count */
                                            result.append(foodItem)
                                        }
                                    }
                                    .sorted(by: { $0.date ?? Date() > $1.date ?? Date()})
                                
                                ForEach(nonDuplicateFoodItems, id: \.id) { food in
                                    FoodItemCell(food: food, callback: {
                                        switch self.isInRemoveFoodMode {
                                        case true:
                                            guard let index = viewModel.addedToArray.firstIndex(where: {$0.id == food.id}) else {
                                                print("index error")
                                                return
                                            }
                                            viewModel.addedToArray.remove(at: index)
                                            self.updateCalorieString()
                                        case false:
                                            self.viewModel.addedToArray.append(food)
                                            //print(viewModel.addedToArray.count)
                                            //passed the test print
                                            self.updateCalorieString()
                                        }
                                    }, isInFoodRemoveMode: $isInRemoveFoodMode, addedToArray: $viewModel.addedToArray)
                                }
                            }
                        }.padding(.leading).padding(.trailing)
                        
                        Spacer()
                        
                        Button(action: {
                            if mealEditing == nil {
                                saveNewMeal()
                            } else {
                                editMeal()
                            }
                        }, label: {
                            Text("SAVE")
                                .padding()
                                .foregroundStyle(Color.white)
                                .shadow(radius: 1)
                                .bold()
                                .background {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(Color.blue)
                                }
                        })
                        
                    }
                }
            }
        }.environment(\.colorScheme, .light)
            .onTapGesture {
                self.isFocused = nil
            }
            .onAppear(perform: {
                viewModel.getAllFoods()
                self.getMealDetails()
            })
    }
    
}

extension CreateMealView {
    
    private func shouldShowModeToggle () -> Bool {
        return viewModel.addedToArray.count > 0 || self.isInRemoveFoodMode == true
        
    }
    
    private func saveNewMeal () {
        /*
         Sets/NSSets cannot have duplicate values. This app works, but the meal is only saving one of each food to it.. To be fixed later
         */
        guard !self.title.isEmpty else {
            return
        }
        
        let manager = CoreDataManager.shared
        let context = manager.persistentContainer.viewContext
        
        let meal = Meal(context: context)
        meal.title = self.title
        meal.calories = Int16(self.calories) ?? 0
        
        
        //MARK: NEW FOOD SAVE
        for foodIteration in viewModel.addedToArray {
            let duplicateFood = Food(context: context)
            duplicateFood.calories = foodIteration.calories
            duplicateFood.title = foodIteration.title
            duplicateFood.category = 5
            duplicateFood.date = nil
            let dupFoodModel = FoodModel(food: duplicateFood)
            if let food = duplicateFood as? Food {
                let mealSet = food.mutableSetValue(forKey: "meals")
                mealSet.add(meal)
                let foodsSet = meal.mutableSetValue(forKey: "foods")
                foodsSet.add(food)
            }
        }//MARK: NEW FOOD SAVE
        
        ///Depricated because would cause issue where if deleted a food from foods list, then the food would be removed from the meal
        //        for item in viewModel.addedToArray {
        //            if let food = item.food as? Food {
        //                let mealsSet = food.mutableSetValue(forKey: "meals")
        //                mealsSet.add(meal)
        //
        //                // Add the food to the meal's foods
        //                let foodsSet = meal.mutableSetValue(forKey: "foods")
        //                foodsSet.add(food)
        //                //                print("Food set count: \(foodsSet.count)")
        //            }
        //        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        
        self.dismiss()
    }
        
    private func editMeal () {
        guard mealEditing != nil else {
            
            return
        }
        
        let date = mealEditing?.date
        let category = mealEditing?.category
        
       let mealToDelete = CoreDataManager.shared.getMealById(mealEditing!.meal.objectID)
        if let mealToDelete {
            CoreDataManager.shared.deleteMeal(mealToDelete)
        }
        
        
        guard !self.title.isEmpty else {
            return
        }
        
        let manager = CoreDataManager.shared
        let context = manager.persistentContainer.viewContext
        
        let meal = Meal(context: context)
        meal.title = self.title
        meal.calories = Int16(self.calories) ?? 0
        meal.category = category!
        meal.date = date
        
        //MARK: NEW FOOD SAVE
        for foodIteration in viewModel.addedToArray {
            let duplicateFood = Food(context: context)
            duplicateFood.calories = foodIteration.calories
            duplicateFood.title = foodIteration.title
            duplicateFood.category = 5
            duplicateFood.date = nil
            let dupFoodModel = FoodModel(food: duplicateFood)
            if let food = duplicateFood as? Food {
                let mealSet = food.mutableSetValue(forKey: "meals")
                mealSet.add(meal)
                let foodsSet = meal.mutableSetValue(forKey: "foods")
                foodsSet.add(food)
            }
        }//MARK: NEW FOOD SAVE
        
        do {
            try context.save()
        } catch {
            print("Failed to save")
        }
        self.dismiss.callAsFunction()
        
//        let manager = CoreDataManager.shared
//        mealEditing?.meal.calories = Int16(self.calories) ?? 0
//        mealEditing?.meal.title = self.title
//        
//        //START
//        
//        //FIRST REMOVE
//        if let foodsSet = mealEditing?.meal.foods as? NSMutableSet {
//            foodsSet.removeAllObjects()
//        }
//        
//        for foodIteration in viewModel.addedToArray {
//            let duplicateFood = Food(context: manager.persistentContainer.viewContext)
//            duplicateFood.calories = foodIteration.calories
//            duplicateFood.title = foodIteration.title
//            duplicateFood.category = 5
//            duplicateFood.date = nil
//            if let food = duplicateFood as? Food {
//                let mealSet = food.mutableSetValue(forKey: "meals")
//                mealSet.add(mealEditing?.meal)
//                let foodsSet = mealEditing!.meal.mutableSetValue(forKey: "foods")
//                foodsSet.add(food)
//            }
//        }
//        
        //MARK: This works, but it would be ideal to remove foods from Core Data if they have no assigned date, category == 5, and they are NOT assigned to a meal.
        
        ///Depricated because would cause issue where if deleted a food from foods list, then the food would be removed from the meal
        //        for item in viewModel.addedToArray {
        //            if let food = item.food as? Food {
        //                let mealsSet = food.mutableSetValue(forKey: "meals")
        //                mealsSet.add(mealEditing?.meal)
        //
        //                // Add the food to the meal's foods
        //                let foodsSet = mealEditing!.meal.mutableSetValue(forKey: "foods")
        //                foodsSet.add(food)
        //            }
        //        }
        
//        do {
//            try manager.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//        //END
//        manager.save()
//        self.dismiss()
    }

    
    private func getMealDetails () {
        guard mealEditing != nil else {
            return
        }
        self.title = mealEditing?.title ?? ""
        let calorieString = String(mealEditing?.calories ?? 0)
        self.calories = calorieString
        //start
        if let foodsSet = mealEditing!.meal.foods, foodsSet.count > 0 {
            if let foodsArray = foodsSet.allObjects as? [Food] {
                let foodModels = foodsArray.map { food in
                    // Assuming FoodModel has an initializer that takes a Food object
                    return FoodModel(food: food)
                }
                viewModel.foods.append(contentsOf: foodModels)
            }
        }
    }
    
    private func updateCalorieString () {
        var total: Int16 = 0
        for i in viewModel.addedToArray {
            total += i.calories
        }
        self.calories = String(total)
    }
}

#Preview {
    CreateMealView(mealEditing: nil)
}

//
//  AddFoodSheet.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

class AddFoodSheetViewModel: ObservableObject {
    @Published var allFoods: [FoodModel] = []
    @Published var allFoodsAndMeals: [FoodItemProtocol] = []
    
    func getAllFoods () {
        self.allFoods = CoreDataManager.shared.getAllFoods().map(FoodModel.init)
    }
    
    func getEverything () {
        let allFoods = CoreDataManager.shared.getAllFoods().map(FoodModel.init)
        let allMeals = CoreDataManager.shared.getAllMeals().map(MealModel.init)
        self.allFoodsAndMeals = allFoods + allMeals
    }
}

struct FoodAddBox: View {
    let foodItem: FoodItemProtocol
    let date: Date
    @Environment(\.dismiss) var dismiss
    @Binding var categoryString: String
    var callbackMethod: () -> ()
    
    private var energyUnitString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return foodItem.calories == 1 ? "calorie" : "calories"
        case .kilojoules:
            return "kJ"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(foodItem.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(foodItem.calories) \(energyUnitString)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: {
                    if foodItem.isMeal {
                        saveAsMeal(date: self.date)
                    } else if !foodItem.isMeal {
                        saveAsFood(date: self.date)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
                .padding(.trailing)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.2))
            )
        }.preferredColorScheme(.light)
        .frame(width: 200, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.3))
        )
        .shadow(radius: 5)
    }
    private func saveAsFood (date: Date) {
        let manager = CoreDataManager.shared
        let newFood = Food(context: manager.persistentContainer.viewContext)
        newFood.title = foodItem.title
        newFood.calories = foodItem.calories
        newFood.date = date
        switch self.categoryString {
        case "Breakfast":
            newFood.category = 1 //breakfast
        case "Lunch":
            newFood.category = 2 //lunch
        case "Dinner":
            newFood.category = 3 //dinner
        case "Snack":
            newFood.category = 4 //snack
        default:
            newFood.category = 1 //breakfast
        }
        manager.save()
        HapticManager.shared.impact()
        callbackMethod()
        self.dismiss.callAsFunction()
    }
    
    private func saveAsMeal (date: Date) {
        let manager = CoreDataManager.shared
        let newMeal = Meal(context: manager.persistentContainer.viewContext)
        newMeal.title = foodItem.title
        newMeal.calories = foodItem.calories
        newMeal.date = date
            //MARK: CHANGE 1
        if let mealItem = foodItem as? MealModel {
            newMeal.foods = mealItem.meal.foods
        } else { print ("cannot type cast")}
            //MARK: CHANGE 1
        switch self.categoryString {
        case "Breakfast":
            newMeal.category = 1 //breakfast
        case "Lunch":
            newMeal.category = 2 //lunch
        case "Dinner":
             newMeal.category = 3 //dinner
        case "Snack":
            newMeal.category = 4 //snack
        default:
            newMeal.category = 1 //breakfast
        }
        manager.save()
        HapticManager.shared.impact()
        callbackMethod()
        self.dismiss.callAsFunction()
    }
}


struct AddFoodSheet: View {
    @StateObject var viewModel: AddFoodSheetViewModel = AddFoodSheetViewModel()
    @State var title: String = ""
    @State var calories: String = ""
    @State var selectedMeal = "Breakfast"
    @State var viewMeals: Bool = false
    @Environment(\.dismiss) var dismiss
    let dateForFood: Date
    var delegate: DataReloadDelegate?
    let mealOptions = ["Breakfast", "Lunch", "Dinner", "Snack"]
    let foodEditing: FoodModel?
    @State var showErrorLabel: Bool = false
    @State var aMealWasAdded: Bool = false
    @State var foodSearched: String = ""
    @FocusState var foodSearchFocus: Bool
    
    private var energyUnitString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return "Calories"
        case .kilojoules:
            return "kJ"
        }
    }
    
    private var foodItemsDisplayed: [FoodItemProtocol] {
        guard !foodSearched.isEmpty else {
            let mostRecentFoodItems = viewModel.allFoodsAndMeals
            return mostRecentFoodItems
        }
        return viewModel.allFoods.filter { foods in
            foods.title.lowercased().contains(self.foodSearched.lowercased())
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient.glassGradientColors.ignoresSafeArea()
                .onTapGesture {
                    self.foodSearchFocus = false
                }
            VStack {
                if self.foodEditing == nil {
                    HStack(spacing: 5) {
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing, 10)
                            .onTapGesture {
                                foodSearchFocus = true
                            }
                        TextField("Search", text: $foodSearched)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: UIScreen.main.bounds.width / 1.4, height: 20)
                            .focused($foodSearchFocus)
                            .submitLabel(.search)
                    }
                    .padding(.top, 30)
                }

                //Possibly want to show 20 most recent...
                if self.foodEditing == nil {
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 20) {
                            
                            let itemsToShow = foodItemsDisplayed
                                .sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
                                .reduce(into: [String: FoodItemProtocol](), { result, foodItem in
                                    if result[foodItem.title] == nil {
                                        result[foodItem.title] = foodItem
                                    }
                                })
                                .values
                                .sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
                                .prefix(30)
                            
                            ForEach(itemsToShow, id: \.id) { foodItem in
                                FoodAddBox(foodItem: foodItem, date: self.dateForFood, categoryString: self.$selectedMeal, callbackMethod: {
                                    delegate?.reloadData()
                                })
                            }
                        }.padding(.top, 70)
                            .padding(.leading, 12)
                            .padding(.trailing, 12)
                        
                    }
                }
                Text(foodEditing == nil ? "Add Food" : "Edit Food")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 100, height: 2)
                    .foregroundStyle(Color.black)
                
                if self.foodEditing == nil {
                    Button {
                        self.viewMeals = true
                    } label: {
                        Text("Select from meals")
                            .font(.caption)
                    }
                    .fullScreenCover(isPresented: $viewMeals, onDismiss: {
                        delegate?.reloadData()
                        if aMealWasAdded {
                            self.dismiss.callAsFunction()
                        }
                    }, content: {
                        AllMealsView(date: dateForFood, categoryOption: selectedMeal, aMealWasAdded: $aMealWasAdded)
                    })
                }

                
                if showErrorLabel {
                    Text("Add a Title and \(self.energyUnitString)")
                        .bold()
                        .foregroundStyle(Color.red)
                }
                Spacer()
                VStack(spacing: 20) {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 140)
                    TextField("\(self.energyUnitString)", text: $calories)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 140)
                        .keyboardType(.numberPad)
                }
                Spacer()
             
                Picker("", selection: $selectedMeal) {
                    ForEach(mealOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.wheel)
                
                Button(action: {
                    if self.foodEditing == nil {
                        self.save()
                    } else {
                        self.editFood()
                    }
                }, label: {
                    Text("SAVE")
                        .bold()
                        .padding()
                        .foregroundStyle(Color.white)
                        .background() {
                            RoundedRectangle(cornerRadius: 10.0)
                                .foregroundStyle(Color.blue)
                                .frame(height: 30)
                        }
                })
                
            }
        }.environment(\.colorScheme, .light)
        .onAppear() {
            viewModel.getAllFoods()
            viewModel.getEverything()
            self.getMealDetails()
        }
    }
    private func save () {
        guard self.title != "" && self.calories != "" else {
            showErrorLabel = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                withAnimation() {
                    showErrorLabel = false
                }
            })
            return
        }
        let manager = CoreDataManager.shared
        let food = Food(context: manager.persistentContainer.viewContext)
        food.title = title
        food.calories = Int16(calories) ?? 0
        food.date = self.dateForFood
        switch self.selectedMeal {
        case "Breakfast":
            food.category = 1 //breakfast
        case "Lunch":
            food.category = 2 //lunch
        case "Dinner":
            food.category = 3 //dinner
        case "Snack":
            food.category = 4 //snack
        default:
            food.category = 1 //breakfast
        }
        manager.save()
        delegate?.reloadData()
        self.dismiss.callAsFunction()
    }
    
    private func editFood () {
        let manager = CoreDataManager.shared
        self.foodEditing?.food.title = self.title
        self.foodEditing?.food.calories = Int16(self.calories) ?? 0
        switch self.selectedMeal {
        case "Breakfast":
            foodEditing?.food.category = 1 //breakfast
        case "Lunch":
            foodEditing?.food.category = 2 //lunch
        case "Dinner":
            foodEditing?.food.category = 3 //dinner
        case "Snack":
            foodEditing?.food.category = 4 //snack
        default:
            foodEditing?.food.category = 1 //breakfast
        }
        manager.save()
        
        delegate?.reloadData()
        self.dismiss.callAsFunction()
    }
    
    private func getMealDetails () {
        guard self.foodEditing != nil else {
            return
        }
        self.title = foodEditing?.title ?? ""
        let calorieString = String(foodEditing?.calories ?? 0)
        self.calories = calorieString
        switch foodEditing?.category {
        case 1:
            self.selectedMeal = "Breakfast"
        case 2:
            self.selectedMeal = "Lunch"
        case 3:
            self.selectedMeal = "Dinner"
        case 4:
            self.selectedMeal = "Snack"
        default:
            self.selectedMeal = "Breakfast"
        }
    }
}

#Preview {
    AddFoodSheet(dateForFood: Date(), foodEditing: nil)
}

//
//  AllMealsView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

//ADD A MEAL TO YOUR DAY FROM HERE AND DISMISS

class AllMealsViewModel : ObservableObject {
    @Published var meals: [MealModel] = [MealModel]()
    
    func getAllMeals () {
        let allMeals = CoreDataManager.shared.getAllMeals()
        DispatchQueue.main.async {
            self.meals = allMeals.map(MealModel.init).filter({$0.date == nil})
        }
    }
    
    func deleteMeal (meal: Meal) {
        CoreDataManager.shared.deleteMeal(meal)
    }
    
    func saveMealToDay (meal: MealModel, date: Date, category: Int16) {
        let manager = CoreDataManager.shared
//        meal.meal.date = date
//        meal.meal.category = category
        
        ///This code prevents an issue where when adding meals, the meal is removed from a previous say where it was used.
        let mealToSave = Meal(context: manager.persistentContainer.viewContext)
        mealToSave.foods = meal.meal.foods
        mealToSave.date = date
        mealToSave.calories = meal.calories
        mealToSave.category = category
        mealToSave.title = meal.title
        manager.save()
        
        
    }
}

struct MealRowItem: View {
    let meal: MealModel
    let dateToAdd: Date
    @State var goToMealEdit: Bool = false
    @StateObject var viewModel: AllMealsViewModel
    @State var showMealDetails: Bool = false
    @State var showCategoryOptions: Bool = false
    var mealReloader: MealReloaderDelegate?
    let categoryOption: String?
    @Environment(\.dismiss) var dismiss
    @Binding var aMealWasAdded: Bool
    var categoryOptionInt16: Int16 {
        switch categoryOption {
        case "Breakfast":
            return 1
        case "Lunch":
            return 2
        case "Dinner":
            return 3
        case "Snack":
            return 4
        default:
            return 1
        }
    }
    
    var body: some View {
            HStack {
                Text(meal.title)
                    .foregroundStyle(Color.black)
                    .fontWeight(.semibold)
                Spacer()
                
                Text("\(meal.calories) calories")
                    .foregroundStyle(Color.blue)
                    .bold()
                    .onTapGesture {
                        self.showMealDetails = true
                    }
                
                Button(action: {
                    goToMealEdit = true
                }, label: {
                    Image(systemName: "pencil.circle")
                        .resizable()
                        .foregroundStyle(Color.yellow)
                        .frame(width: 25, height: 25)
                })
                
                
            }.padding()
            
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteMeal(meal: meal.meal)
                        viewModel.getAllMeals()
                    } label: {
                        Text("DELETE")
                    }
                    
                    Button(action: {
                        if self.categoryOption == nil {
                            showCategoryOptions = true
                        } else {
                            viewModel.saveMealToDay(meal: meal, date: self.dateToAdd, category: categoryOptionInt16)
                            aMealWasAdded = true
                            self.dismiss.callAsFunction()
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .tint(Color.green)
                    })
                }
        
            .sheet(isPresented: $showMealDetails, onDismiss: {}, content: {
                MealDetails(meal: meal)
        })
            .sheet(isPresented: $showCategoryOptions, onDismiss: {}, content: {
                CategoryOptionsSubview(meal: self.meal, viewModel: self.viewModel, dateToAdd: self.dateToAdd, completion: {
                    self.dismiss()
                })
            })
            .sheet(isPresented: $goToMealEdit, onDismiss: {
                mealReloader?.reloadAllMeals()
            }, content: {
                CreateMealView(mealEditing: meal, dismissOpacity: 0)
            })
    }
}


struct AllMealsView: View, MealReloaderDelegate {
    @StateObject var viewModel: AllMealsViewModel = AllMealsViewModel()
    @State var searchText: String = ""
    @State var addMeal: Bool = false
    let date: Date
    let categoryOption: String?
    @Environment(\.dismiss) var dismiss
    @FocusState var isFocused
    @Binding var aMealWasAdded: Bool
    var filteredMeals: [MealModel] {
        guard !searchText.isEmpty else {
            return viewModel.meals
        }
        return viewModel.meals.filter { result in
            result.title.lowercased().contains(searchText.lowercased())
        }
    }
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
                VStack {
                    DismissButton {
                        self.dismiss()
                    }.padding(.bottom)
                    if viewModel.meals.count > 0 {
                        TextField("Search for a meal...", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .focused($isFocused)
                    }
                    Divider()
                    if viewModel.meals.count > 0 {
                        Text("Swipe an item to add or delete")
                            .font(.callout)
                            .fontDesign(.rounded)
                            .foregroundStyle(Color.gray)
                            .bold()
                    }
                    List {
                        if viewModel.meals.count > 0 {
                            ForEach(filteredMeals, id: \.id) { meal in
                                MealRowItem(meal: meal, dateToAdd: self.date, viewModel: viewModel, mealReloader: self, categoryOption: self.categoryOption, aMealWasAdded: $aMealWasAdded)
                            }
                        } else {
                            Button(action: {
                                self.addMeal = true
                            }, label: {
                                Text("Create your first meal 🍏")
                                    .foregroundStyle(Color.blue)
                                    .bold()
                            })
                        }
                    }.listStyle(.plain)
                    HStack {
                        Spacer()
                        Button(action: {
                            self.addMeal = true
                        }, label: {
                            Image(systemName: "plus")
                                .bold()
                                .padding()
                                .foregroundStyle(Color.white)
                                .background() {
                                    Circle()
                                        .foregroundStyle(Color.black)
                                }
                        })
                    }.padding()
                }.padding(.top)
        }.environment(\.colorScheme, .light)
        .sheet(isPresented: $addMeal, onDismiss: {
            viewModel.getAllMeals()
        }, content: {
            CreateMealView(mealEditing: nil, dismissOpacity: 0)
        })
        .onAppear() {
            viewModel.getAllMeals()
        }
        .preferredColorScheme(.light)
    }
    func reloadAllMeals() {
        self.viewModel.getAllMeals()
    }
}



#Preview {

    AllMealsView(date: Date(), categoryOption: nil, aMealWasAdded: .constant(false))
}

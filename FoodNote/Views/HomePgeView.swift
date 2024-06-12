//
//  HomePgeView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI

class HomePgeViewModel: ObservableObject, DataReloadDelegate { //Conforming for use of preview only
    
    @Published var allFoods: [FoodModel] = [FoodModel]()
    @Published var allMeals: [MealModel] = [MealModel]()
    @Published var everything: [FoodItemProtocol] = []
    
    func reloadData () {
            self.getAllFoods()
            self.getAllMeals()
            self.getEverything()
    }
    
    func getAllFoods () {
        let foods = CoreDataManager.shared.getAllFoods()
        DispatchQueue.main.async {
            self.allFoods = foods.map(FoodModel.init)
        }
    }
    
    func getAllMeals () {
        let meals = CoreDataManager.shared.getAllMeals()
        DispatchQueue.main.async {
            self.allMeals = meals.map(MealModel.init)
        }
    }
    
    func getEverything() {
        let foods = CoreDataManager.shared.getAllFoods().map(FoodModel.init)
        let meals = CoreDataManager.shared.getAllMeals().map(MealModel.init)
        DispatchQueue.main.async {
            self.everything = foods + meals
        }
    }
}

struct HomePgeView: View , DataReloadDelegate {
    @State var date: Date = Date()
    @State var caloriesForDay: Int16 = 0
    @StateObject var viewModel: HomePgeViewModel = HomePgeViewModel()
    let user: User
    @State private var showPlusMenu: Bool = false
    @State private var showAddFoodSheetBreakfastDefault: Bool = false
    @State private var showAddFoodLunch: Bool = false
    @State private var showAddFoodDinner: Bool = false
    @State private var showAddFoodSnack: Bool = false
    @State private var showAddMealSheet: Bool = false
    @State private var showViewAllMealsSheet: Bool = false
    @State private var scrollViewXOffset: CGFloat = 0
    @State private var scrollViewOpacity: Double = 1
    @State private var showWeightLog: Bool = false
    @State var buttonShouldBeActive: Bool = true
    @State var opacityIsMuted: Bool = false
//    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Spacer()
                TopRowView(user: user, date: $date, calories: $caloriesForDay, buttonShouldBeActive: $buttonShouldBeActive, opacityIsMuted: $opacityIsMuted, completionLeftToggle: self.animateBackward, completionRightToggle: self.animateForward, reloadDelegate: self)
                    .padding((.bottom))
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text("Breakfast")
                            .foregroundStyle(Color.black)
                            .bold()
                            .opacity(opacityIsMuted ? 0 : 1)
                        breakfastList
                            .opacity(opacityIsMuted ? 0.3 : 1)
                            .preferredColorScheme(.light)
                        Text("Lunch")
                            .opacity(opacityIsMuted ? 0.3 : 1)
                            .foregroundStyle(Color.black)
                            .bold()
                        lunchList
                            .opacity(opacityIsMuted ? 0.5 : 1)
                            .preferredColorScheme(.light)
                        Text("Dinner")
                            .foregroundStyle(Color.black)
                            .bold()
                            .opacity(opacityIsMuted ? 0.5 : 1)
                        dinnerList
                            .opacity(opacityIsMuted ? 0.7 : 1)
                            .preferredColorScheme(.light)
                        Text("Snack")
                            .opacity(opacityIsMuted ? 0.8 : 1)
                            .foregroundStyle(Color.black)
                            .bold()
                        snackList
                            .opacity(opacityIsMuted ? 0.85 : 1)
                            .preferredColorScheme(.light)
                    }
                    .offset(x: scrollViewXOffset)
                    
                }.padding()
                .background() {
                    Rectangle()
                        .foregroundStyle(Color.gray).opacity(0.1)
                        .frame(width: UIScreen.main.bounds.width)
                }
                
                HStack {
                    tipsButtonHStack
                    Spacer()
                    if !showPlusMenu {
                        plusButtonHStack
                    } else {
                        plusMenuOptions
                            .offset(x: -25.0, y: -20.0)
                    }
                }
            }.environment(\.colorScheme, .light)
            .animation(.easeOut, value: self.date)
        }
        
        //MARK: AddFoodSheets
        .sheet(isPresented: $showAddFoodSheetBreakfastDefault, onDismiss: {
        }, content: {
            AddFoodSheet(selectedMeal: "Breakfast", dateForFood: self.date, delegate: self, foodEditing: nil)
        })
        
        .sheet(isPresented: $showAddFoodLunch, onDismiss: {
        }, content: {
            AddFoodSheet(selectedMeal: "Lunch", dateForFood: self.date, delegate: self, foodEditing: nil)
        })
        .sheet(isPresented: $showAddFoodDinner, onDismiss: {
        }, content: {
            AddFoodSheet(selectedMeal: "Dinner", dateForFood: self.date, delegate: self, foodEditing: nil)
        })
        .sheet(isPresented: $showAddFoodSnack, onDismiss: {
        }, content: {
            AddFoodSheet(selectedMeal: "Snack", dateForFood: self.date, delegate: self, foodEditing: nil)
        })
        //MARK: AddFoodSheets end of .sheet modifiers code
        
        .fullScreenCover(isPresented: $showAddMealSheet, onDismiss: {}, content: {
            CreateMealView(mealEditing: nil)
        })
        .fullScreenCover(isPresented: $showViewAllMealsSheet, onDismiss: {
            self.reloadData()
        }, content: {
            AllMealsView(date: self.date, categoryOption: nil, aMealWasAdded: .constant(false))
        })
        .fullScreenCover(isPresented: $showWeightLog, onDismiss: {
            self.viewModel.reloadData()
        }, content: {
            WeightLogView(user: self.user)
        })
        .onAppear() {
            self.viewModel.reloadData()
            self.updateCalories()
        }
    }
    
    func reloadData() {
        self.updateCalories()
        viewModel.reloadData()
    }
}

extension HomePgeView {
    
    func updateCalories () {
        var caloriesEaten: Int16 = 0
        let allFoodsWithDates = CoreDataManager.shared.getAllFoods().map(FoodModel.init).filter({$0.date != nil})
        let filteredTodayFoods = allFoodsWithDates.filter({$0.date!.isSameDay(as: self.date)})
        for food in filteredTodayFoods {
            caloriesEaten += food.calories
        }
        
        let allMealsWithDates = CoreDataManager.shared.getAllMeals().map(MealModel.init).filter({$0.date != nil})
        let filteredTodayMeals = allMealsWithDates.filter({$0.date!.isSameDay(as: self.date)})
        for meal in filteredTodayMeals {
            caloriesEaten += meal.calories
        }
        
        self.caloriesForDay = caloriesEaten
    }
}

extension HomePgeView {
    var breakfastList: some View {
        List {
            let everything = viewModel.everything.filter({$0.category == 1})
            let everythingWithDate = everything.filter({$0.date != nil})
            let allUsableFoodObjects = everythingWithDate.filter({$0.date!.isSameDay(as: self.date)})

            if allUsableFoodObjects.count < 1 {
                Button(action: {
                    showAddFoodSheetBreakfastDefault = true
                }, label: {
                    Text("What's for breakfast? ☕️")
                        .bold()
                        .foregroundStyle(Color.blue)
                })
            } else {
                ForEach(allUsableFoodObjects, id: \.id) { food in
                        FoodRow(food: food, callback: {
                            self.reloadData()
                        }, date: self.date)
                }
                Button(action: {
                    showAddFoodSheetBreakfastDefault = true
                }, label: {
                    Text("Add?")
                        .bold()
                        .foregroundStyle(Color.blue)
                })
            }
        }
        .hideScrollBar()
        .padding()
        .frame(width: 320, height: 160)
            .listStyle(.plain)
            .background() {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.darkPurple)
            }
    }
        
    var lunchList: some View {
        List {
            let everything = viewModel.everything.filter({$0.category == 2})
            let everythingWithDate = everything.filter({$0.date != nil})
            let allUsableFoodObjects = everythingWithDate.filter({$0.date!.isSameDay(as: self.date)})
            

            if allUsableFoodObjects.count < 1 {
                Button(action: {
                    showAddFoodLunch = true
                }, label: {
                    Text("What's for lunch? 🥗")
                        .bold()
                        .foregroundStyle(Color.blue)
                })
            } else {
                ForEach(allUsableFoodObjects, id: \.id) { food in
                    FoodRow(food: food, callback: {
                        self.reloadData()
                    }, date: self.date)
                }
                Button(action: {
                    showAddFoodLunch = true
                }, label: {
                    Text("More lunch items?")
                        .bold()
                        .foregroundStyle(Color.blue)
                })
            }
        }

        .hideScrollBar()
        .padding()
        .frame(width: 320, height: 160)
        .listStyle(.plain)
        .background() {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.darkPurple)
        }
    }
    
    var dinnerList: some View {
        List {

            let everything = viewModel.everything.filter({$0.category == 3})
            let everythingWithDate = everything.filter({$0.date != nil})
            let allUsableFoodObjects = everythingWithDate.filter({$0.date!.isSameDay(as: self.date)})

            if allUsableFoodObjects.count < 1 {
                Button(action: {
                    showAddFoodDinner = true
                }, label: {
                    Text("What's for dinner? 🥦")
                        .bold()
                        .foregroundStyle(Color.blue)
                })
            } else {
                ForEach(allUsableFoodObjects, id: \.id) { food in
                    FoodRow(food: food, callback: {
                        self.reloadData()
                    }, date: self.date)
                }
                Button(action: {
                    showAddFoodDinner = true
                }, label: {
                    Text("Still hungry?")
                        .bold()
                        .foregroundStyle(Color.blue)
                })
            }
        }
        .hideScrollBar()
        .padding()
        .frame(width: 320, height: 160)
        .listStyle(.plain)
        .background() {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.darkPurple)
        }
    }
    
    var snackList: some View {
        List {
            let everything = viewModel.everything.filter({$0.category == 4})
            let everythingWithDate = everything.filter({$0.date != nil})
            let allUsableFoodObjects = everythingWithDate.filter({$0.date!.isSameDay(as: self.date)})

            if allUsableFoodObjects.count < 1 {
                Button(action: {
                    showAddFoodSnack = true
                }, label: {
                    Text("Snacks? 😋")
                        .bold()
                        .foregroundStyle(Color.blue)
                })
            } else {
                ForEach(allUsableFoodObjects, id: \.id) { food in
                    FoodRow(food: food, callback: {
                        self.reloadData()
                    }, date: self.date)
                }
                Button(action: {
                    showAddFoodSnack = true
                }, label: {
                    Text("More snacks? 🍉")
                        .bold()
                        .foregroundStyle(Color.blue)
                })

            }
        }
        .hideScrollBar()
        .padding()
        .frame(width: 320, height: 160)
        .listStyle(.plain)
        .background() {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.darkPurple)
        }

    }
    
    ///Plus Button inside of and HStack
    var plusButtonHStack: some View {
        HStack {
            Button(action: {
                withAnimation {
                    showPlusMenu = true
                }
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
        }.padding(.trailing)
    }
    
    ///Tips Button inside of and HStack
    var tipsButtonHStack: some View {
        HStack {
            Button(action: {
                showWeightLog = true
            }, label: {
                Image(systemName: "chart.xyaxis.line")
                    .bold()
                    .padding()
                    .foregroundStyle(Color.white)
                    .background() {
                        Circle()
                            .foregroundStyle(Color.black)
                    }
            })
        }.padding(.leading)
    }
    
    var plusMenuOptions: some View {
        VStack(spacing: 12) {
            Button("+ FOOD", action: {
                withAnimation(.easeInOut(duration: 1.9)) {
                    showPlusMenu = false
                }
                showAddFoodSheetBreakfastDefault = true
            })
            
            Button("+ CREATE MEAL", action: {
                withAnimation(.easeInOut(duration: 1.9)) {
                    showPlusMenu = false
                }
                showAddMealSheet = true
            })
            
            Button("VIEW MEALS", action: {
                withAnimation(.easeInOut(duration: 1.9)) {
                    showPlusMenu = false
                }
                self.showViewAllMealsSheet = true
            })
                        
            Button("DONE", action: {
                withAnimation(.bouncy, {
                    self.showPlusMenu = false
                })
            })
            
            
        }.padding()
            .foregroundStyle(Color.blue)
            .bold()
        .background() {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.white)
                .shadow(radius: 2)
        }.padding()
    }
}

#Preview {
    HomePgeView(user: User())
}

extension HomePgeView {
    
    private func animateForward () {
        buttonShouldBeActive = false
        withAnimation(.linear(duration: 0.2)) {
            scrollViewXOffset = -UIScreen.main.bounds.width
        }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    self.scrollViewXOffset = UIScreen.main.bounds.width
            })
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.4, execute: {
                self.reset()
            buttonShouldBeActive = true
            })
    }
    
    private func animateBackward () {
        buttonShouldBeActive = false
        withAnimation(.linear(duration: 0.2)) {
            scrollViewXOffset = UIScreen.main.bounds.width
        }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    self.scrollViewXOffset = -UIScreen.main.bounds.width
            })
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.4, execute: {
                self.reset()
                buttonShouldBeActive = true
            })
    }
    
    private func reset () {
        withAnimation(.linear(duration: 0.2)) {
            self.scrollViewXOffset = 0
        }
        self.updateCalories()
    }
}

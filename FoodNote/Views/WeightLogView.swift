//
//  WeightLogView.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI
import UIKit

class WeightLogViewModel : ObservableObject, DeletetionProtocol {
    @Published var loggedWeights: [LoggedWeightModel] = []
    
    init () {
        self.getAllLogs()
    }
    
    func measurementString (user: UserBasicsManager) -> String {
        switch UnitManager.shared.getUnitPreference() {
        case .lbs:
            return "lbs"
        case .kg:
            return "kgs"
        case .stone:
            return "stone"
        }
    }
    
    func getAllLogs () {
        let loggedWeights = CoreDataManager.shared.getAllLoggedWeights()
        DispatchQueue.main.async {
            self.loggedWeights = loggedWeights.map(LoggedWeightModel.init)
        }
    }
    
    func deleteWeightLog ( _ loggedWeight: LoggedWeight) {
        let manager = CoreDataManager.shared
        manager.deleteLoggedWeight(loggedWeight)
        self.getAllLogs()
    }
}

struct WeightCell: View {
    let weightModel: LoggedWeightModel
    var delegate: DeletetionProtocol?
    var user: UserBasicsManager
    
     var measurementString: String {
        switch UnitManager.shared.getUnitPreference() {
        case .lbs:
            return "LBS"
        case .kg:
            return "KGs"
        case .stone:
            return "Stone"
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text("\(weightModel.weight.with1Decimal()) \(self.measurementString)")
                Spacer()
                Text("\(weightModel.dateLogged.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(Color.black)
            }.padding()
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: {
                delegate?.deleteWeightLog(weightModel.loggedWeight)
            }, label: {
                Image(systemName: "trash")
            })
        }
    }
}

struct WeightLogView: View {
    @Environment(\.dismiss) var dismiss
    let user: UserBasicsManager
    @StateObject var viewModel: WeightLogViewModel = WeightLogViewModel()
    @State var goToLogWeightView: Bool = false
    @State var updateCaloricGoal: Bool = false
    
    private var weightString: String {
        switch UnitManager.shared.getUnitPreference() {
        case .lbs:
            return "\(goalWeight) \("lbs")"
        case .kg:
            return "\(goalWeight) \("KGs")"
        case .stone:
            return "\(goalWeight) \("stone")"
        }
    }
    
    private var goalWeight: String {
        return String(user.getUserGoalWeight().with1Decimal())
    }
    var body: some View {
        ZStack {
            LinearGradient.glassGradientColors.ignoresSafeArea()
            VStack() {
                DismissButton(action: {
                    self.dismiss()
                })
                Text("Progress")
                    .font(.largeTitle)
                    .bold()
                Divider()
                Text("My goal: \(weightString)")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundStyle(Color.indigo)
                Divider()
                VStack() {
                    if viewModel.loggedWeights.count > 0 {
                        List(viewModel.loggedWeights.sorted(by: {$0.dateLogged > $1.dateLogged})) { weightData in
                            WeightCell(weightModel: weightData, delegate: viewModel.self, user: user)
                                .listRowBackground(Color.clear)
                                .glass(cornerRadius: 10, fill: .yellow)
//                                .background() {
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .foregroundStyle(Color.white)
//                                        .shadow(radius: 1)
//                                }
                                .padding()
                        }.listStyle(.plain)
                          
                    } else {
                        List {
                            Button(action: {
                                goToLogWeightView = true
                            }, label: {
                                HStack {
                                    Text("Log your weight")
                                        .bold()
                                    Image(systemName: "pencil")
                                        .foregroundStyle(Color.yellow)
                                    
                                }
                            })
                            .listRowBackground(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color.pink.opacity(0.3), location: 0.0),
                                        Gradient.Stop(color: Color.blue.opacity(0.4), location: 0.5),
                                        Gradient.Stop(color: Color.purple.opacity(0.2), location: 1.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        }
                        .listStyle(.plain)
                    }
                }
                    
                Spacer()
//                HStack {
//                    Button(action: {
//                        goToLogWeightView = true
//                    }, label: {
//                            Image(systemName: "scalemass")
//                                .resizable()
//                                .foregroundStyle(Color.white)
//                                .frame(width: 20, height: 20)
//                                .padding()
//                                .background {
//                                    Circle()
//                                        .foregroundColor(.black)
//                                }
//                    })
//                    Spacer()
//                    Button(action: {
//                        self.updateCaloricGoal = true
//                    }, label: {
//                        Image(systemName: "slider.horizontal.3")
//                            .resizable()
//                            .foregroundStyle(Color.white)
//                            .frame(width: 20, height: 20)
//                            .padding()
//                            .background {
//                                Circle()
//                                    .foregroundColor(.black)
//                            }
//                    })
//                }.padding()
                HStack {
                    Button(action: {
                        goToLogWeightView = true
                    }, label: {
                        Image(systemName: "scalemass")
                            .resizable()
                            .foregroundStyle(Color.gray)
                            .frame(width: 20, height: 20)
                            .padding()
                            .background {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.25),
                                                Color.blue.opacity(0.15),
                                                Color.white.opacity(0.1),
                                                Color.clear
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .stroke(Color.gray, lineWidth: 1)
                            }
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.updateCaloricGoal = true
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .foregroundStyle(Color.gray)
                            .frame(width: 20, height: 20)
                            .padding()
                            .background {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.25),
                                                Color.blue.opacity(0.15),
                                                Color.white.opacity(0.1),
                                                Color.clear
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .stroke(Color.gray, lineWidth: 1)
                            }
                    })
                }
                .padding()

            }
        }.environment(\.colorScheme, .light)
        .onAppear() {
            viewModel.getAllLogs()
        }
        .fullScreenCover(isPresented: $goToLogWeightView, onDismiss: {
            viewModel.getAllLogs()
        }, content: {
            InfoSheet(seguedFromSettings: true)
        })
        .fullScreenCover(isPresented: $updateCaloricGoal, onDismiss: {
            
        }, content: {
            CaloriesView(user: user, seguedFromProgressView: true, calorieRecommendationAmount: user.calorieGoal)
        })
        .preferredColorScheme(.light)
    }
}




#Preview {
    WeightLogView(user: UserBasicsManager())
}

//
//  CalorieViewController.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import UIKit
import SwiftUI

class CalorieViewController: UIViewController {
    
    private var unitString: String {
        switch UnitManager.shared.getUserEnergyPreference() {
        case .cal:
            return "calories"
        case .kilojoules:
            return "kJ"
        }
    }
        
    var calorieAmount: Int = 1000 {
        didSet {
            caloriesTextLabel.text = String(calorieAmount) + " \(unitString)"
        }
    }
    
    var user: UserBasicsManager
    var seguedFromProgressView: Bool = false
    
    init(calorieAmount: Int, user: UserBasicsManager, seguedFromProgressView: Bool = false) {
        self.calorieAmount = calorieAmount
        self.user = user
        self.seguedFromProgressView = seguedFromProgressView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var caloriesTextLabel: UILabel = {
        let label = UILabel()
        label.text = String(self.calorieAmount) + " \(unitString)"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var disclaimerLabel: UILabel = {
       let label = UILabel()
        label.text = "Note: The ByteLogs App does not recommend a specific caloric intake. Please consult a nutritionist for personalized advice."
        label.numberOfLines = .max
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE & AGREE", for: .normal)
        button.layer.cornerRadius = 15
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
     var adjustmentSlider: UISlider = {
       let slider = UISlider()
         slider.minimumValue = switch UnitManager.shared.getUserEnergyPreference() {
         case .cal:
             500
         case .kilojoules:
             2000
         }
         slider.maximumValue = switch UnitManager.shared.getUserEnergyPreference() {
         case .cal:
             4000
         case .kilojoules:
             16000
         }
         
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = .gray
        slider.widthAnchor.constraint(equalToConstant: 200).isActive = true
         
         slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        return slider
    }()
    
    private var xButton: UIButton = {
        let button = UIButton(type: .system)
        let xImage = UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        button.setImage(xImage, for: .normal)
        button.addTarget(self, action: #selector(xButtonClicked), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.overrideUserInterfaceStyle = .light
        configureView()
        self.adjustmentSlider.value = Float(self.calorieAmount)
        //set slider value to recommended amount
        //set self.calorieAmount to recommened amount
    }
    
    @objc func sliderValueChanged(sender: UISlider) {
        let step: Float = 5.0
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        self.calorieAmount = Int(sender.value)
    }
    
    @objc func xButtonClicked () {
        self.dismiss(animated: true)
    }

    @objc func saveButtonPressed () {
        //
        if self.seguedFromProgressView {
            let calorieInteger = Int(adjustmentSlider.value)
            self.user.saveCalorieGoal(goal: calorieInteger)
            self.dismiss(animated: true, completion: nil)
        } else if !self.seguedFromProgressView {
            self.user.saveUserLoadedApp()
            let calorieInteger = Int(adjustmentSlider.value)
            self.user.saveCalorieGoal(goal: calorieInteger)
            let homePgView = HomePgeView(user: self.user)
            let hostingController = UIHostingController(rootView: homePgView)
            hostingController.modalPresentationStyle = .fullScreen
            hostingController.modalTransitionStyle = .flipHorizontal
            present(hostingController, animated: true)
        }
    }
    
    func configureView () {
        
        let uiStack = UIStackView(arrangedSubviews: [
            caloriesTextLabel,
            adjustmentSlider,
        ])
        
        uiStack.axis = .vertical
        view.addSubview(uiStack)
        uiStack.translatesAutoresizingMaskIntoConstraints = false
        uiStack.spacing = 50
        uiStack.widthAnchor.constraint(equalToConstant: 200)
            .isActive = true
        NSLayoutConstraint.activate([
            uiStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
        
        view.addSubview(disclaimerLabel)
        
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            disclaimerLabel.topAnchor.constraint(equalTo: uiStack.bottomAnchor, constant: 20),
            disclaimerLabel.centerXAnchor.constraint(equalTo: uiStack.centerXAnchor)
        ])
        
        if self.seguedFromProgressView {
            view.addSubview(xButton)
            xButton.translatesAutoresizingMaskIntoConstraints = false
            xButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            xButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            xButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
            xButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        }
        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: disclaimerLabel.bottomAnchor, constant: 120),
            saveButton.centerXAnchor.constraint(equalTo: disclaimerLabel.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 170)
        ])

    }
    
}




struct CaloriesView: UIViewControllerRepresentable {
    let user: UserBasicsManager
    var seguedFromProgressView: Bool = false
    
    let calorieRecommendationAmount: Int
    func makeUIViewController(context: Context) -> some UIViewController {
        return CalorieViewController(calorieAmount: calorieRecommendationAmount, user: user, seguedFromProgressView: seguedFromProgressView)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct CaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(user: UserBasicsManager(), calorieRecommendationAmount: 1300)
    }
}

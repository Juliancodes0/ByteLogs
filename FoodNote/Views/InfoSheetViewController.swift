//
//  InfoSheetViewController.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import UIKit
import SwiftUI

class InfoSheetViewController: UIViewController {
    
    let user = User()
    var seguedFromSettings: Bool = false
    
    init(seguedFromSettings: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.seguedFromSettings = seguedFromSettings
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var enterInfoTextLabel: UILabel = {
       let label = UILabel()
        label.text = !self.seguedFromSettings ? "Enter some info about you" : "Update weight"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "LBS"
        textField.textColor = UIColor.black
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        return textField
    }()
    
    private lazy var goalWeightTextField: UITextField = {
        let textField = UITextField()
         textField.placeholder = "Goal Weight"
         textField.textColor = UIColor.black
         textField.borderStyle = .roundedRect
         textField.translatesAutoresizingMaskIntoConstraints = false
         textField.keyboardType = .decimalPad
         textField.textAlignment = .center
         return textField
    }()
    
    private var xButton: UIButton = {
        let button = UIButton(type: .system)
        let xImage = UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        button.setImage(xImage, for: .normal)
        button.addTarget(self, action: #selector(xButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private var errorLabel: UILabel = {
       let label = UILabel()
        label.text = "Enter current weight and a goal"
        label.textAlignment = .center
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.widthAnchor.constraint(equalToConstant: 170).isActive = true
        label.alpha = 0
        return label
    }()
    
    var showErrorLabel: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.overrideUserInterfaceStyle = .light
        self.setup()
    }
    
    func runPossibleErrorAnimations() {
        guard !(weightTextField.text?.isEmpty ?? true) && !(goalWeightTextField.text?.isEmpty ?? true) else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.errorLabel.alpha = 1
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.errorLabel.alpha = 0
                    })
                }
            })
            return
        }
    }

    @objc func doneButtonClicked () {
        //MARK: USER DEFAULTS START CODE
        runPossibleErrorAnimations()
        if self.seguedFromSettings && ((weightTextField.text?.isEmpty ?? true)) && ((goalWeightTextField.text?.isEmpty ?? true)) {
            self.dismiss(animated: true)
        }
        
        guard let userWeightText = weightTextField.text else {
            
            return
        }
        guard let userWeightDouble = Double(userWeightText) else {
            return
        }
                
        let manager = CoreDataManager.shared
        let weight = LoggedWeight(context: manager.persistentContainer.viewContext)
        weight.weight = userWeightDouble
        weight.dateLogged = Date()
        manager.save()
        
        guard let userGoalText = goalWeightTextField.text else {return}
        guard let userGoalDouble = Double(userGoalText) else {return}
        self.user.saveUserGoalWeight(weight: userGoalDouble)
        
        if !self.seguedFromSettings {
            self.user.saveUserLoadedApp()
        }
        
        //MARK: USER DEFAULTS END CODE
        
        if self.seguedFromSettings {
            self.dismiss(animated: true, completion: nil)
        } else if !self.seguedFromSettings {
            let vc = CalorieViewController(calorieAmount: self.getCalorieGoal(), user: self.user)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true)
        }
    }
    
    @objc func xButtonClicked () {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setup () {
        view.addSubview(enterInfoTextLabel) //add to view first
        enterInfoTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        enterInfoTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [
        weightTextField,
        goalWeightTextField,
        ])
        
        if self.seguedFromSettings {
            view.addSubview(xButton)
            xButton.translatesAutoresizingMaskIntoConstraints = false
            xButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            xButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            xButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
            xButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        }
        
        weightTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true
        weightTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        goalWeightTextField.widthAnchor.constraint(equalToConstant: 120).isActive = true
        goalWeightTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stack.spacing = 60
        stack.axis = .vertical
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: enterInfoTextLabel.bottomAnchor, constant: 60).isActive = true
        
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 40).isActive = true
        
        view.addSubview(doneButton)
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func getCalorieGoal () -> Int {
        guard let weightInt = Int(weightTextField.text ?? "1") else {return 0}
        guard let goalWghtInt = Int(goalWeightTextField.text ?? "1") else {return 0}
        if weightInt > goalWghtInt {
            return 1700
        } else {
            return 2300
        }
    }
}


struct InfoSheet: UIViewControllerRepresentable {
    var seguedFromSettings: Bool = false
    func makeUIViewController(context: Context) -> some UIViewController {
        return InfoSheetViewController(seguedFromSettings: seguedFromSettings)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


#Preview {
    InfoSheet()
}

///InfoSheetViewControllerDeprecated
//class InfoSheetViewControllerDeprecated: UIViewController {
//    let user = User()
//    var seguedFromSettings: Bool = false
//
//    init(seguedFromSettings: Bool) {
//        super.init(nibName: nil, bundle: nil)
//        self.seguedFromSettings = seguedFromSettings
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private lazy var enterInfoTextLabel: UILabel = {
//        let label = UILabel()
//        label.text = !self.seguedFromSettings ? "Enter some info about you" : "Update weight"
//        label.textColor = .white
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 24, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private lazy var weightTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "LBS"
//        textField.textColor = UIColor.black
//        textField.borderStyle = .roundedRect
//        textField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.keyboardType = .decimalPad
//        textField.textAlignment = .center
//        return textField
//    }()
//
//    private lazy var goalWeightTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Goal Weight"
//        textField.textColor = UIColor.black
//        textField.borderStyle = .roundedRect
//        textField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.keyboardType = .decimalPad
//        textField.textAlignment = .center
//        return textField
//    }()
//
//    private var xButton: UIButton = {
//        let button = UIButton(type: .system)
//        let xImage = UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
//        button.setImage(xImage, for: .normal)
//        button.addTarget(self, action: #selector(xButtonClicked), for: .touchUpInside)
//        return button
//    }()
//
//    private var doneButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("DONE", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
//        button.backgroundColor = UIColor.white.withAlphaComponent(0.8)
//        button.setTitleColor(.blue, for: .normal)
//        button.layer.cornerRadius = 15
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.3
//        button.layer.shadowOffset = CGSize(width: 0, height: 5)
//        button.layer.shadowRadius = 10
//        button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupGradientBackground()
//        self.setup()
//    }
//
//    @objc func doneButtonClicked() {
//        // MARK: USER DEFAULTS START CODE
//
//        if self.seguedFromSettings && ((weightTextField.text?.isEmpty) != nil) && ((goalWeightTextField.text?.isEmpty) != nil) {
//            self.dismiss(animated: true)
//        }
//
//        guard let userWeightText = weightTextField.text else { return }
//        guard let userWeightDouble = Double(userWeightText) else { return }
//
//        let manager = CoreDataManager.shared
//        let weight = LoggedWeight(context: manager.persistentContainer.viewContext)
//        weight.weight = userWeightDouble
//        weight.dateLogged = Date()
//        manager.save()
//
//        guard let userGoalText = goalWeightTextField.text else { return }
//        guard let userGoalDouble = Double(userGoalText) else { return }
//        self.user.saveUserGoalWeight(weight: userGoalDouble)
//
//        if !self.seguedFromSettings {
//            self.user.saveUserLoadedApp()
//        }
//
//        // MARK: USER DEFAULTS END CODE
//
//        if self.seguedFromSettings {
//            self.dismiss(animated: true, completion: nil)
//        } else if !self.seguedFromSettings {
//            let vc = CalorieViewController(calorieAmount: self.getCalorieGoal(), user: self.user)
//            vc.modalPresentationStyle = .fullScreen
//            vc.modalTransitionStyle = .flipHorizontal
//            present(vc, animated: true)
//        }
//    }
//
//    @objc func xButtonClicked() {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func setup() {
//        view.addSubview(enterInfoTextLabel) // Add to view first
//
//        enterInfoTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
//        enterInfoTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        let stack = UIStackView(arrangedSubviews: [
//            weightTextField,
//            goalWeightTextField,
//        ])
//        stack.spacing = 20
//        stack.axis = .vertical
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stack)
//        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        stack.topAnchor.constraint(equalTo: enterInfoTextLabel.bottomAnchor, constant: 40).isActive = true
//
//        weightTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        weightTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        goalWeightTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        goalWeightTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        view.addSubview(doneButton)
//        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
//        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        doneButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        if self.seguedFromSettings {
//            view.addSubview(xButton)
//            xButton.translatesAutoresizingMaskIntoConstraints = false
//            xButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
//            xButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//        }
//    }
//
//    func setupGradientBackground() {
//        let gradientLayer = CAGradientLayer()
//        let safeAreaInsets = view.safeAreaInsets
//        let frame = CGRect(
//            x: view.bounds.origin.x,
//            y: view.bounds.origin.y - safeAreaInsets.top,
//            width: view.bounds.width,
//            height: view.bounds.height + safeAreaInsets.top + safeAreaInsets.bottom
//        )
//        gradientLayer.frame = frame
//        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        view.layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//
//    func getCalorieGoal() -> Int {
//        guard let weightInt = Int(weightTextField.text ?? "1") else { return 0 }
//        guard let goalWghtInt = Int(goalWeightTextField.text ?? "1") else { return 0 }
//        return weightInt > goalWghtInt ? 1700 : 2300
//    }
//}

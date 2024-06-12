//
//  UnitOptionsViewController.swift
//  FoodNote
//
//  Created by Julian 沙 on 6/9/24.
//

import UIKit
import SwiftUI

enum SelectedWeightOption {
    case lbs
    case kg
    case stone
}

enum SelectedEnergyUnit {
    case cal
    case kcal
}

class UnitOptionsViewController: UIViewController {
    
    var user: User
    weak var delegate: ReloadStringDataDelegate?
    var selectedOption: SelectedWeightOption = .lbs
    var selectedEnergyUnit: SelectedEnergyUnit = .cal
    
    private var unitPreferenceLabel: UILabel = {
       let label = UILabel()
        label.text = "Unit Preference"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    private var lbsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LBS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(selectLbs), for: .touchUpInside)
        return button
    }()
    
    private var kgButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kilogram", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(selectKg), for: .touchUpInside)
        return button
    }()
    
    private var stoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stone", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(selectStone), for: .touchUpInside)
        return button
    }()
    
    private lazy var dividerLine: UIView = {
        let dividerView: UIView = UIView()
        dividerView.backgroundColor = .gray
        dividerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return dividerView
    }()
    
    private var calButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Calories", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(selectCal), for: .touchUpInside)
        return button
    }()
    
    private var kcalButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("KCal", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(selectKCal), for: .touchUpInside)
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    @objc func selectLbs () {
        self.selectedOption = .lbs
        self.lbsButton.backgroundColor = .systemBlue
        self.kgButton.backgroundColor = .lightGray
        self.stoneButton.backgroundColor = .lightGray
    }
    
    @objc func selectKg () {
        self.selectedOption = .kg
        self.kgButton.backgroundColor = .systemBlue
        self.lbsButton.backgroundColor = .lightGray
        self.stoneButton.backgroundColor = .lightGray
    }
    
    @objc func selectStone () {
        self.selectedOption = .stone
        self.stoneButton.backgroundColor = .systemBlue
        self.lbsButton.backgroundColor = .lightGray
        self.kgButton.backgroundColor = .lightGray
    }
    
    @objc func selectCal () {
        self.selectedEnergyUnit = .cal
        self.calButton.backgroundColor = .systemBlue
        self.kcalButton.backgroundColor = .lightGray
    }
    
    @objc func selectKCal () {
        self.selectedEnergyUnit = .kcal
        self.kcalButton.backgroundColor = .systemBlue
        self.calButton.backgroundColor = .lightGray
    }
    
    @objc func saveButtonPressed () {
        switch self.selectedOption {
        case .lbs:
            user.saveUserUnitPreference(preference: .lbs)
        case .kg:
            user.saveUserUnitPreference(preference: .kg)
        case .stone:
            user.saveUserUnitPreference(preference: .stone)
        }
        
        switch self.selectedEnergyUnit {
        case .cal:
            user.saveUserEnergyPreference(preference: .cal)
        case .kcal:
            user.saveUserEnergyPreference(preference: .kcal)
        }
        self.dismiss(animated: true, completion: {
            self.delegate?.reloadStringData()
        })
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.overrideUserInterfaceStyle = .light
        arrange()
        
        switch user.getUnitPreference() {
        case .lbs:
            self.selectedOption = .lbs
            self.lbsButton.backgroundColor = .systemBlue
            self.kgButton.backgroundColor = .lightGray
            self.stoneButton.backgroundColor = .lightGray
        case .kg:
            self.selectedOption = .kg
            self.lbsButton.backgroundColor = .lightGray
            self.kgButton.backgroundColor = .systemBlue
            self.stoneButton.backgroundColor = .lightGray
        case .stone:
            self.selectedOption = .stone
            self.lbsButton.backgroundColor = .lightGray
            self.kgButton.backgroundColor = .lightGray
            self.stoneButton.backgroundColor = .systemBlue
        }
        
        switch user.getUserEnergyPreference() {
           
        case .cal:
            self.selectedEnergyUnit = .cal
            self.calButton.backgroundColor = .systemBlue
            self.kcalButton.backgroundColor = .lightGray
        case .kcal:
            self.selectedEnergyUnit = .kcal
            self.calButton.backgroundColor = .lightGray
            self.kcalButton.backgroundColor = .systemBlue
        }
        
    }
    
    func arrange () {
        
        view.addSubview(unitPreferenceLabel)
        unitPreferenceLabel.translatesAutoresizingMaskIntoConstraints = false
        unitPreferenceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unitPreferenceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        
        let weightButtonStack: UIStackView = UIStackView(arrangedSubviews: [
            lbsButton,
            kgButton,
            stoneButton
        ])
        
//        self.lbsButton.backgroundColor = selectedOption == .lbs ? .systemBlue : .clear
//        self.kgButton.backgroundColor = selectedOption == .kg ? .systemBlue : .lightGray
//        self.stoneButton.backgroundColor = selectedOption == .stone ? .systemBlue : .lightGray

        weightButtonStack.translatesAutoresizingMaskIntoConstraints = false
        weightButtonStack.axis = .vertical
        weightButtonStack.spacing = 40
        view.addSubview(weightButtonStack)
        weightButtonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weightButtonStack.topAnchor.constraint(equalTo: unitPreferenceLabel.safeAreaLayoutGuide.topAnchor, constant: 90).isActive = true
        view.addSubview(dividerLine)
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        dividerLine.centerXAnchor.constraint(equalTo: weightButtonStack.centerXAnchor).isActive = true
        dividerLine.topAnchor.constraint(equalTo: weightButtonStack.bottomAnchor, constant: 16).isActive = true
        
        let energyUnitStack: UIStackView = UIStackView(arrangedSubviews: [
        calButton,
        kcalButton
        ])
        
        energyUnitStack.translatesAutoresizingMaskIntoConstraints = false
        energyUnitStack.axis = .vertical
        energyUnitStack.spacing = 40
        view.addSubview(energyUnitStack)
        energyUnitStack.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 40).isActive = true
        energyUnitStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

struct UnitViewControllerRepresentative: UIViewControllerRepresentable {
    var seguedFromSettings: Bool = false
    func makeUIViewController(context: Context) -> some UIViewController {
        return UnitOptionsViewController(user: User())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


#Preview {
    UnitViewControllerRepresentative()
}

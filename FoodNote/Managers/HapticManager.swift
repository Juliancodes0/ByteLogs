//
//  HapticManager.swift
//  FoodNote
//
//  Created by Julian 沙 on 6/2/24.
//

import Foundation
import UIKit


class HapticManager {
    
    static let shared = HapticManager()
    
    func notify () {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func impact () {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

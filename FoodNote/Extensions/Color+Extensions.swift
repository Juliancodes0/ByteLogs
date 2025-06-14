//
//  Color+Extensions.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import SwiftUI
import UIKit

extension Color {
    static let darkPurple = Color(red: 72/255, green: 61/255, blue: 139/255)
    static let lavenderColor = Color(red: 200/255, green: 162/255, blue: 200/255)
    static let highligterPink = Color(red: 255/255, green: 182/255, blue: 193/255).opacity(0.3)
    static let glass = Color.white.opacity(0.2)
}

extension UIColor {
    static let glass = UIColor.white.withAlphaComponent(0.2)
}

extension LinearGradient {
    static let glassGradientColors: LinearGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color.white.opacity(0.3), location: 0.0),
            .init(color: Color.indigo.opacity(0.4), location: 0.25),
            .init(color: Color.pink.opacity(0.2), location: 0.5),
            .init(color: Color.gray.opacity(0.1), location: 0.75),
            .init(color: Color.clear, location: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

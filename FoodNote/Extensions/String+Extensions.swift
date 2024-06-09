//
//  String+Extensions.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import Foundation

extension Double {
     func with2Decimals () -> String {
        return String(format: "%.2f", self)
    }
    func with1Decimal () -> String {
       return String(format: "%.1f", self)
   }
}

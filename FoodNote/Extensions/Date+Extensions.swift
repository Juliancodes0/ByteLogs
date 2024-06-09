//
//  Date+Extensions.swift
//  FoodNote
//
//  Created by Julian 沙 on 5/31/24.
//

import Foundation

extension Date {
    
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.day, .month, .year], from: self)
        let components2 = calendar.dateComponents([.day, .month, .year], from: otherDate)
        
        return components1.day == components2.day &&
               components1.month == components2.month &&
               components1.year == components2.year
    }
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.string(from: self)
    }
}

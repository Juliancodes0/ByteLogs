//
//  Sequence+Extensions.swift
//  FoodNote
//
//  Created by Julian 沙 on 6/4/24.
//

import Foundation

extension Sequence {
    func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return self.filter({seen.insert($0[keyPath: keyPath]).inserted})
    }
    func unique(by areEquivalent: (Element, Element) -> Bool) -> [Element] {
        var uniqueElements: [Element] = []
        
        for element in self {
            if !uniqueElements.contains(where: { areEquivalent($0, element) }) {
                uniqueElements.append(element)
            }
        }
        
        return uniqueElements
    }
}
